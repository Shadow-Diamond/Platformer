extends Node2D

@onready var virellia = $Virellia
@onready var camera = $Camera2D
@onready var planets = []

var cur_planet = null
var cur_planet_index = 0
var planet_list_size = null

func _ready():
	planets.append(virellia)
	cur_planet = planets[0]
	planet_list_size = planets.size()

func _physics_process(_delta):
	if Input.is_action_just_pressed("Right"):
		var newIndex = cur_planet_index + 1
		if newIndex < planet_list_size:
			cur_planet_index = newIndex
			cur_planet = planets[newIndex]
			camera.position.x = cur_planet.position.x
	elif Input.is_action_just_pressed("Left"):
		var newIndex = cur_planet_index - 1
		if newIndex >= 0:
			cur_planet_index = newIndex
			cur_planet = planets[newIndex]
			camera.position.x = cur_planet.position.x

func _on_button_pressed():
	GameManager.load_scene(GameManager.Levels["Virellia"][1])
