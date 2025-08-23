extends "res://Scripts/enemy_template.gd"

func _ready() -> void:
	_self_kill_box = null
	_speed = 30

func _enemy_death(_object): 
	pass

func _fall(delta):
	if not is_on_floor() and _mobile:
		velocity += get_gravity() * delta
