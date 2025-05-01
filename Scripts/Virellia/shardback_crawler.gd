extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../Player"
@onready var kill_box: Area2D = $kill_box

@export var stationary: bool = true

var delayed: bool = false

func _ready() -> void:
	sprite.play("Idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
	
	if !stationary:
		pass

func _on_kill_box_body_entered(body: CharacterBody2D) -> void:
	if body == player:
		print("Enemy damage player signal")
		player.emit_signal("hit_player")
