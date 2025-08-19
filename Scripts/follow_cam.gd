extends Camera2D

#@onready var player = $"../Player"

#func _physics_process(_delta):
	#if !player.death():
		#self.global_position = player.cam_pos()

func _ready() -> void:
	SignalBus.connect("player_pos", _move)

func _move(_player_pos):
	self.global_position = _player_pos
