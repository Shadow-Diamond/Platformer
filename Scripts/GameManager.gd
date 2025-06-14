extends Node

@onready var Levels = {
	"Misc":{
		"MainMenu": 1,
		"LevelSelect": "res://Level-Scenes/LevelSelect.tscn"
	},
	"Virellia": {
		1: "res://Level-Scenes/Virellia/Virellia_1.tscn"
	}
}

var current_level = null

var remaining_lives = 3

var currency : int = 0

func _ready():
	current_level = Levels["Misc"]["LevelSelect"]

func load_scene(scene):
	if scene == null:
		scene = Levels["Misc"]["MainMenu"]
		
	current_level = scene
	var loaded = load(scene)
	get_tree().change_scene_to_packed(loaded)
