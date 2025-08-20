extends CharacterBody2D

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _detection_area: Area2D = $detection_area

func _ready() -> void:
	_sprite.play("Idle")
	_detection_area.body_entered.connect(_collision)

func _collision(object):
	if object.is_in_group("player"):
		SignalBus.collect.emit(10, 1)
		self.queue_free()
