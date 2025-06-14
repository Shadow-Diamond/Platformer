extends CharacterBody2D

@onready var player: CharacterBody2D = $"../Player"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $detection_area

var hit = false

func _ready() -> void:
	sprite.play("Idle")
	detection_area.monitoring = false

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body == player and not hit:
		hit = true
		player.emit_signal("collectable")
		self.queue_free()

func collision_activate():
	detection_area.monitoring = true
