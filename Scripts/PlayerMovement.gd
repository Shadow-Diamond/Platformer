extends CharacterBody2D

@export var Speed : float
@export var Jump_Velocity : float
@export var kill_bounce_decrease: int

var dead = false
var health = 1

signal hit_player
signal kill_bounce

func _ready() -> void:
	connect("hit_player", Callable(self, "_on_hit_player"))
	connect("kill_bounce", Callable(self, "_on_kill_bounce"))

func _physics_process(delta: float) -> void:
	
	if not dead:
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
	else:
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func _on_hit_player():
	print("Damage signal received")
	match(health):
		1:
			dead = true
			health -= 1
		2:
			health -= 1
		3:
			health -= 1

func _on_kill_bounce():
	velocity.y = -Jump_Velocity/kill_bounce_decrease
