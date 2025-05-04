extends CharacterBody2D

@onready var player = $"../Player"

func _on_area_2d_body_entered(body):
	if body == player:
		player.emit_signal("kill_player")
