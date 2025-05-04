extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../Player"
@onready var kill_box: Area2D = $kill_box
@onready var delay_timer = $delay_timer
@onready var ground_detector_1 = $GroundDetector1
@onready var ground_detector_2 = $GroundDetector2
@onready var ground_detector_delay = $ground_detector_delay

@export var stationary: bool = true
var behavior: bool = true
var fallable: bool

static var speed = 10
var flip_val = false
var delayed: bool = false
var prev_pos = null
var cur_pos = null
var flip_mult = -1

func _ready() -> void:
	sprite.play("Idle")
	ground_detector_1.enabled = false
	ground_detector_2.enabled = false
	ground_detector_delay.start()

func _physics_process(delta: float) -> void:
	if behavior:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if !stationary:
			sprite.play("Walk")
			sprite.flip_h = flip_val
			velocity.x = speed * flip_mult
			cur_pos = self.position.x
			if cur_pos == prev_pos and !delayed or !ground_detector_1.is_colliding() and !delayed and !fallable or !ground_detector_2.is_colliding() and !delayed and !fallable:
				flip_mult *= -1
				flip_val = !flip_val
				delay_timer.start()
				delayed = true
			prev_pos = cur_pos
		
		move_and_slide()

func _on_kill_box_body_entered(body: CharacterBody2D) -> void:
	if body == player:
		print("Enemy damage player signal")
		player.emit_signal("hit_player")


func _on_delay_timer_timeout():
	delayed = false

func start_behavior():
	behavior = true


func _on_ground_detector_delay_timeout():
	ground_detector_1.enabled = true
	ground_detector_2.enabled = true
