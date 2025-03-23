extends CharacterBody2D

signal hitPlayer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent().get_name() == "Player":
		print("Hit Player")
		hitPlayer.emit()
