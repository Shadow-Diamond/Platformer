extends TextEdit

@onready var player: CharacterBody2D = $"../Player"
@onready var score_box: TextEdit = $"."

var player_cam_pos
var score_display = 0
var current_score = 0

func _physics_process(_delta):
	player_cam_pos = player.cam_pos()
	player_cam_pos.x -= 950
	player_cam_pos.y -= 530
	
	self.global_position = player_cam_pos
	update_score()

func update_score():
	current_score = player._get_score()
	if score_display != current_score:
		score_display = current_score
		score_box.text = "Score: " + str(score_display)
