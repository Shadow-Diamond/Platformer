extends CharacterBody2D


@export var Speed : float
@export var Jump_Velocity : float


func _physics_process(delta: float) -> void:
	
	# Handles the gravity of the Character
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() and Input.is_action_just_pressed("Up"):
		velocity.y = -Jump_Velocity
	
	# Handles the X-axis movement of the Character
	if Input.is_action_pressed("Left"):
		velocity.x = -Speed
	elif Input.is_action_pressed("Right"):
		velocity.x = Speed
	else:
		velocity.x = 0
	
	move_and_slide()
