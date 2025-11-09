extends CharacterBody2D

func _on_area_2d_body_entered(object):
	if object.is_in_group("player"):
		SignalBus.kill_player.emit()
