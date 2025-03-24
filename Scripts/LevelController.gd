extends Node

signal playerDamage

var player

func _ready():
	player = get_node("Player")
	connect("hitPlayer", _player_damaged.bind())

func _player_damaged():
	playerDamage.emit()
