extends TextEdit

@onready var player: CharacterBody2D = get_node("../Player")
@onready var _scorebox: TextEdit = $"."

var player_cam_pos
var _score_display = 0

func _ready():
	SignalBus.collect.connect(_update_scorebox)
	SignalBus.e_death.connect(_update_scorebox)
	SignalBus.level_fin.connect(_update_gm)

func _physics_process(_delta):
	player_cam_pos = player.cam_pos()
	player_cam_pos.x -= 950
	player_cam_pos.y -= 530
	self.global_position = player_cam_pos

func _update_scorebox(_amount):
	_score_display += _amount
	_scorebox.text = "Score: " + str(_score_display)

func _update_gm():
	SignalBus.gm_update_score.emit(_score_display)
