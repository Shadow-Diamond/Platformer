extends TextEdit

@onready var score_box: TextEdit = $"."

func _physics_process(_delta: float) -> void:
	var score_display = GameManager.currency
	score_box.text = "Score: " + str(score_display)
