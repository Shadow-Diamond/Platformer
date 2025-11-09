extends Node

@onready var Levels = {
	"Misc":{
		"MainMenu": "res://Level-Scenes/MainMenu.tscn",
		"LevelSelect": "res://Level-Scenes/LevelSelect.tscn"
	},
	"Virellia": {
		1: "res://Level-Scenes/Virellia/Virellia_1.tscn",
		2: "res://Level-Scenes/Virellia/Virellia_2.tscn",
		3: "res://Level-Scenes/Virellia/Virellia_3.tscn",
		4: "res://Level-Scenes/Virellia/Virellia_4.tscn",
		5: "res://Level-Scenes/Virellia/Virellia_5.tscn"
	},
	"Giltera": {
		
	},
	"Chromatic_Bonuses": {
		1: "res://Level-Scenes/Virellia/Virellia_Bonus_Level_6.tscn"
	}
}

@onready var num_levels_per_planet = {
	"Virellia": 5,
	"Giltera": 0,
	"Chromatic_Bonuses": 1
}

@onready var num_levels_comp = {
	"Virellia": 0,
	"Giltera": 0,
	"Chromatic_Bonuses": 1
}

@onready var purchased_planet = {
	"Virellia": true,
	"Giltera": false,
	"Chromatic_Bonuses": false
}

@onready var purchase_price = {
	"Virellia": 0,
	"Giltera": 100,
	"Chromatic_Bonuses": 100
}

var current_level = null
var level_num = null
var level_cat = null
var paused = false

var player_suit = "basic_suit"

var currency : int = 0

var _pause_menu_scene = preload("res://Level-Scenes/pause_menu.tscn")
var _pause_menu
var osType

func _ready():
	osType = OS.get_name()
	set_process_mode(Node.PROCESS_MODE_ALWAYS) 
	var _canvas = CanvasLayer.new()
	add_child(_canvas)
	_pause_menu = _pause_menu_scene.instantiate()
	_canvas.add_child(_pause_menu)
	_pause_menu.hide()
	
	current_level = Levels["Misc"]["MainMenu"]
	
	# Signals from SignalBus
	SignalBus.e_death.connect(_enemy_died)
	SignalBus.reset.connect(_reset)
	SignalBus.gm_update_score.connect(_update_score)

func load_scene(scene):
	if scene == null:
		scene = Levels["Misc"]["LevelSelect"]
	level_num = scene[-6]
	level_num = int(level_num)
	if level_num is not int:
		level_num = null
	var first_pos = scene.find("/")
	first_pos+=1
	var second_pos = scene.find("/", first_pos+1)
	var third_pos = scene.find("/", second_pos+1)
	level_cat = scene.substr(second_pos+1, third_pos-(second_pos+1))
	current_level = scene
	var loaded = load(scene)
	get_tree().change_scene_to_packed(loaded)

func fin_level():
	var scene = Levels["Misc"]["LevelSelect"]
	unlock_levels()
	load_scene(scene)

func unlock_levels():
	print("Unlock LVL ", level_num)
	match(level_num):
		1:
			if num_levels_comp[level_cat] <= 0:
				num_levels_comp[level_cat] = 1
		2:
			if num_levels_comp[level_cat] == 1:
				num_levels_comp[level_cat] = 2
		3:
			if num_levels_comp[level_cat] == 2:
				num_levels_comp[level_cat] = 3
		4:
			if num_levels_comp[level_cat] == 3:
				num_levels_comp[level_cat] = 4
		5:
			if num_levels_comp[level_cat] == 4:
				num_levels_comp[level_cat] = 5

func get_num_levels_available():
	return num_levels_comp

func get_num_levels_max():
	return num_levels_per_planet

func _enemy_died():
	_increase_score(1)

func _increase_score(value: int):
	currency += value

func create_timer(parent: Node, wait: float, callback: Callable):
	var t := Timer.new()
	t.one_shot = true
	t.wait_time = wait
	parent.add_child(t)
	t.timeout.connect(callback)
	t.timeout.connect(func(): t.queue_free())
	t.start()
	return t

func _reset():
	load_scene(current_level)

func _update_score(amount):
	currency += amount

func purchase_planet(planet_name):
	if currency < purchase_price[planet_name]:
		return false
	else:
		currency -= purchase_price[planet_name]
		purchased_planet[planet_name] = true

func _input(_event):
	if _event.is_action_pressed("Pause") and current_level != Levels["Misc"]["LevelSelect"]:
		if get_tree().paused:
			unpause()
		else:
			get_tree().paused = true
			_pause_menu.show()

func unpause():
	_pause_menu.hide()
	get_tree().paused = false

func save_status():
	var file = FileAccess.open("res://save.dat", FileAccess.WRITE)
	if file:
		file.store_var(num_levels_comp)
		file.store_var(purchased_planet)
		file.store_var(purchase_price)
		file.store_var(currency)
		file.store_var(player_suit)
		file.close()
	else:
		print("Save failed")

func load_status():
	var file = FileAccess.open("res://save.dat", FileAccess.READ)
	if file:
		var num_levels_comp_dict = {}
		var purchased_dict = {}
		var costs_dict = {}
		var money
		var suit
		if not file.eof_reached():
			num_levels_comp_dict = file.get_var()
			purchased_dict = file.get_var()
			costs_dict = file.get_var()
			money = file.get_var()
			suit = file.get_var()
		file.close()
		num_levels_comp = num_levels_comp_dict
		purchased_planet = purchased_dict
		purchase_price = costs_dict
		currency = money
		player_suit = suit
	else:
		print("Load failed")
	
func quit_level():
	var scene = Levels["Misc"]["LevelSelect"]
	_pause_menu.hide()
	get_tree().paused = false
	load_scene(scene)
