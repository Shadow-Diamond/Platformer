extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../Player"
@onready var kill_box: Area2D = $kill_box
@onready var delay_timer = $delay_timer

@export var stationary: bool = true

static var speed = 10
var flip_val = false
var delayed: bool = false
var prev_pos = null
var cur_pos = null
var flip_mult = -1

func _ready() -> void:
	sprite.play("Idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
	
	if !stationary:
		sprite.play("Walk")
		sprite.flip_h = flip_val
		velocity.x = speed * flip_mult
		cur_pos = self.position.x
		if cur_pos == prev_pos and !delayed:
			flip_mult *= -1
			flip_val = !flip_val
			delay_timer.start()
			delayed = true
		prev_pos = cur_pos

func _on_kill_box_body_entered(body: CharacterBody2D) -> void:
	if body == player:
		print("Enemy damage player signal")
		player.emit_signal("hit_player")


func _on_delay_timer_timeout():
	delayed = false
