extends CharacterBody2D

@onready var player: CharacterBody2D = $"../Player"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var hit = false

func _ready() -> void:
	sprite.play("Idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body == player and not hit:
		hit = true
		player.emit_signal("power_up", "better_suit")
		self.queue_free()
