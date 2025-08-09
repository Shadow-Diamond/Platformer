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
	#SignalBus.collect.connect()

func load_scene(scene):
	if scene == null:
		scene = Levels["Misc"]["MainMenu"]
	level_num = scene[1]
	level_cat = scene[0]
	if level_num is not int:
		level_num = null
	current_level = scene
	var loaded = load(scene)
	get_tree().change_scene_to_packed(loaded)

func fin_level():
	var scene = get_next_level()
	load_scene(scene)

func get_next_level():
	if level_cat == null or level_num == null:
		return Levels["Misc"]["LevelSelect"]

	var remaining = num_levels_remaining()
	if remaining <= 0:
		return Levels["Misc"]["LevelSelect"]

	var next_level = level_num + 1
	if Levels[level_cat].has(next_level):
		return Levels[level_cat][next_level]
	else:
		return Levels["Misc"]["LevelSelect"]

func num_levels_remaining():
	if level_cat == null or level_num == null:
		return 0
	if not num_levels_per_planet.has(level_cat):
		return 0
	var remaining = num_levels_per_planet[level_cat]
	return max(0, remaining - level_num)

func get_num_levels():
	return num_levels_per_planet

func _enemy_died():
	_increase_score(1)

func _increase_score(value: int):
	currency += value
	SignalBus.score_increase.emit(value)

func create_timer(parent: Node, wait: float, callback: Callable):
	var t := Timer.new()
	t.one_shot = true
	t.wait_time = wait
	parent.add_child(t)
	t.timeout.connect(callback)
	t.timeout.connect(func(): t.queue_free())
	t.start()
	return t
