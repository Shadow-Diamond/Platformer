extends CharacterBody2D

@export var Speed : float
@export var Jump_Velocity : float
@export var kill_bounce_decrease: int

@onready var main_camera: Camera2D = $Camera2D
@export var mc_left_marg: float
@export var mc_top_marg: float
@export var mc_right_marg: float
@export var mc_bottom_marg: float

@onready var death_delay: Timer = $death_delay
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var respawn_delay: Timer = $respawn_delay

var dead = false
var health = 1
var death_delay_passed: bool = false
var player_death: bool = false

signal hit_player
signal kill_bounce

func _ready() -> void:
	connect("hit_player", Callable(self, "_on_hit_player"))
	connect("kill_bounce", Callable(self, "_on_kill_bounce"))
	if mc_bottom_marg >= 0 || mc_bottom_marg <= 1:
		main_camera.drag_bottom_margin = mc_bottom_marg
	if mc_left_marg >= 0 || mc_left_marg <= 1:
		main_camera.drag_left_margin = mc_left_marg
	if mc_right_marg >= 0 || mc_right_marg <= 1:
		main_camera.drag_right_margin = mc_right_marg
	if mc_top_marg >= 0 || mc_top_marg <= 1:
		main_camera.drag_top_margin = mc_top_marg

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
	elif not death_delay_passed:
		velocity.x = 0
		velocity.y = 0
	else:
		if !player_death:
			collision_shape_2d.queue_free()
			player_death = true
			velocity.y = -Jump_Velocity/kill_bounce_decrease
			respawn_delay.start()
		velocity += get_gravity() * delta
		
	
	move_and_slide()

func _on_hit_player():
	print("Damage signal received")
	match(health):
		1:
			dead = true
			health -= 1
			death_delay.start()
		2:
			health -= 1
		3:
			health -= 1

func _on_kill_bounce():
	velocity.y = -Jump_Velocity/kill_bounce_decrease


func _on_death_delay_timeout() -> void:
	death_delay_passed = true


func _on_respawn_delay_timeout() -> void:
	pass # Replace with function body.
