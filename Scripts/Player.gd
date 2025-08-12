extends CharacterBody2D

@export var _speed : int
@export var _jump_velocity : int
@export var _kill_bounce_decrease : int

@onready var _main_camera: Camera2D = $Camera2D
@export var _mc_left_marg: float
@export var _mc_top_marg: float
@export var _mc_right_marg: float
@export var _mc_bottom_marg: float
@export var _mc_upper_bound: int = 0

# Space Suits
@onready var _basic_suit : AnimatedSprite2D = $basic_spacesuit
@onready var _better_suit : AnimatedSprite2D = $better_spacesuit
@onready var _jump_suit : AnimatedSprite2D = $jump_spacesuit

# Standard Vars
var _health : int = 1
var _active_suit : AnimatedSprite2D
var _dead : bool = false

func _ready():
	SignalBus.hurt_player.connect(_got_hurt)
	SignalBus.bounce.connect(_bouncy)
	
	match(GameManager.player_suit):
		"basic_suit":
			_better_suit.hide()
			_jump_suit.hide()
			_active_suit = _basic_suit
		"better_suit":
			_health = 2
			_basic_suit.hide()
			_jump_suit.hide()
			_active_suit = _better_suit
		"jump_suit":
			_health = 3
			_basic_suit.hide()
			_better_suit.hide()
			_active_suit = _jump_suit

func _got_hurt():
	match(_health):
		1:
			_dead = true
		2:
			_health-=1
			_active_suit = _basic_suit
		3:
			_health-=1
			_active_suit = _better_suit

func _bouncy():
	velocity.y = -_jump_velocity/_kill_bounce_decrease
