extends AnimatedSprite2D

@onready var spire: AnimatedSprite2D = $"."

var sprite_chosen
func _ready() -> void:
	var max_spires = spire.sprite_frames.get_animation_names().size()
	match(max_spires):
		2:
			sprite_chosen = randi_range(1,2)
	spire.play("Spire" + str(sprite_chosen))
