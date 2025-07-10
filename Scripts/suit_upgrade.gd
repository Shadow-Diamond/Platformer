extends CharacterBody2D

@onready var player: CharacterBody2D = $"../Player"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $detection_area

@export var suit_type: String = "better_suit"

var hit = false
signal collected

func _ready() -> void:
	sprite.play("Idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body == player and not hit:
		hit = true
		emit_signal("collected")
		player.emit_signal("power_up", suit_type)
		self.queue_free()
