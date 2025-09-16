extends Node

@onready var Levels = {
	"Misc":{
		"MainMenu": 1,
		"LevelSelect": "res://Level-Scenes/LevelSelect.tscn"
	},
	"Virellia": {
		1: "res://Level-Scenes/Virellia/Virellia_1.tscn",
		2: "res://Level-Scenes/Virellia/Virellia_2.tscn"
	}
}

@onready var num_levels_per_planet = {
	"Virellia": 2
}

@onready var num_levels_comp = {
	"Virellia": 0
}

var current_level = null
var level_num = null
var level_cat = null

var player_suit = "basic_suit"

var remaining_lives = 3

var currency : int = 0

func _ready():
	current_level = Levels["Misc"]["LevelSelect"]
	
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
