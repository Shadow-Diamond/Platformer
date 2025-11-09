extends "res://Scripts/EnemyOrPlayer/enemy_template.gd"

func _ready() -> void:
	_self_kill_box = null
	_speed = 30

func _enemy_death(_object): 
	pass

func _fall(delta):
	if not is_on_floor() and mobile:
		velocity += get_gravity() * delta

func _attempt_to_hurt_player(object):
	if object.is_in_group("player"):
		print(self.name, " hit Player")
		SignalBus.hurt_player.emit()
	elif object.is_in_group("enemies") and object != self:
		_move_flip(null)
