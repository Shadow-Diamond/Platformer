extends AnimatedSprite2D

@onready var cloud: AnimatedSprite2D = $"."

func _ready():
	var cloudNum = randi_range(1,6)
	match(cloudNum):
		1:
			cloud.play("cloud_1")
		2:
			cloud.play("cloud_2")
		3:
			cloud.play("cloud_3")
		4:
			cloud.play("cloud_4")
		5:
			cloud.play("cloud_5")
		6:
			cloud.play("cloud_6")
