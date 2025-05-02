extends Camera2D

@onready var player = $"../Player"

func _physics_process(_delta):
	if !player.death():
		self.global_position = player.cam_pos()
