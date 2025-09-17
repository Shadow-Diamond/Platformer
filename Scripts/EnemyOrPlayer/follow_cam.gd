extends Camera2D

func _ready() -> void:
	SignalBus.connect("player_pos", _move)

func _move(_player_pos):
	self.global_position = _player_pos
