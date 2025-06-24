extends Node2D

@onready var player: CharacterBody2D = $"../Player"

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body == player:
		player.emit_signal("score_sig")
		GameManager.fin_level()
