extends CharacterBody2D

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _detection_area: Area2D = $detection_area

## Suit name for code purposes. All lowercase, and the suit should be under valid_items
@export var suit_type: String = "better_suit"
## Value of the Suit. Value of 2 means it is on par with the better_suit, Value 3 means the better_suit can't replace it (or other Value 2 suits)
@export var suit_value: int = 2

var hit = false

func _ready() -> void:
	_sprite.play("Idle")
	_detection_area.body_entered.connect(_collision)

func _collision(object):
	print("Collected")
	if object.is_in_group("player"):
		SignalBus.collect.emit(suit_type, suit_value)
		print(suit_type)
		self.queue_free()
