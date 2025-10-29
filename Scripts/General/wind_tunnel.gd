extends Node2D

@export var _Outward = false
@export var _wind_strength = 0

@onready var _windy_area = $WindArea
@onready var _sprite = $AnimatedSprite2D

var _player = null
var _direction

func _ready():
	if _Outward:
		_sprite.play("Outward")
	else:
		_sprite.play("Inward")
	_windy_area.connect("body_entered", object_entered_wind_tunnel)
	_windy_area.connect("body_exited", object_exited_wind_tunnel)

func object_entered_wind_tunnel(_body):
	if _body.is_in_group("player"):
		_player = _body

func object_exited_wind_tunnel(_body):
	if _body.is_in_group("player"):
		_player = null

func _physics_process(_delta: float) -> void:
	_direction = Vector2.RIGHT.rotated(global_rotation)
	if not _Outward:
		_direction = -_direction
	if _player:
		_player.wind_vector += _direction * (_wind_strength*100)
