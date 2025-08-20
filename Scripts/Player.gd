extends CharacterBody2D

@export var _speed : float = 400
@export var _jump_velocity : float = 600
@export var _kill_bounce_decrease : float = 2

@onready var main_camera: Camera2D = $Camera2D
@export var _mc_left_marg: float
@export var _mc_top_marg: float
@export var _mc_right_marg: float
@export var _mc_bottom_marg: float
@export var _mc_upper_bound: int = 0

@onready var hitbox = $HurtBox
@onready var ground_coll = $GroundCollision

# Space Suits
@onready var _basic_suit : AnimatedSprite2D = $basic_spacesuit
@onready var _better_suit : AnimatedSprite2D = $better_spacesuit
@onready var _jump_suit : AnimatedSprite2D = $jump_spacesuit

# Standard Vars
var _health : int = 1
var _active_suit : AnimatedSprite2D
var _suit_val : int = 1
var _dead : bool = false
var _dir : String = "right"
var _djed : bool = false
var _walking : bool = false
var score : int = 0
var _death_fall : bool = false

func _physics_process(delta):
	if not _dead:
		_horizontal()
		_vertical(delta)
	elif _death_fall:
		velocity += get_gravity() * delta
	if is_on_floor():
		_djed = false
	move_and_slide()

func _ready():
	main_camera.make_current()
	#SignalBus.hurt_player.connect(_got_hurt)
	SignalBus.bounce.connect(_bouncy)
	SignalBus.collect.connect(_collect)
	
	match(GameManager.player_suit):
		"basic_suit":
			_active_suit = _basic_suit
		"better_suit":
			_health = 2
			_active_suit = _better_suit
			_suit_val = 2
		"jump_suit":
			_health = 3
			_active_suit = _jump_suit
			_suit_val = 3
	_toggle_anims(_active_suit)

func _got_hurt():
	match(_health):
		1:
			_dead = true
			_death()
		2:
			_health-=1
			_active_suit = _basic_suit
			_suit_val = 1
		3:
			_health-=1
			_active_suit = _better_suit
			_suit_val = 2

func _bouncy():
	velocity.y = -_jump_velocity/_kill_bounce_decrease

func _vertical(delta):
	if _dead:
		return
	if Input.is_action_just_pressed("Up"):
		if _active_suit == _jump_suit and not _djed and not is_on_floor():
			velocity.y = -_jump_velocity
			_djed = true
		elif is_on_floor():
			velocity.y = -_jump_velocity
	elif Input.is_action_just_released("Up"):
		velocity.y *= .5
	elif not is_on_floor():
		velocity += get_gravity() * delta
		var _jumpAnim = "Jump" + _dir
		_active_suit.play(_jumpAnim)

func _horizontal():
	if _dead:
		return
	var _active_animation
	if Input.is_action_pressed("Left"):
		_dir = "left"
		_walking = true
	elif Input.is_action_pressed("Right"):
		_dir = "right"
		_walking = true
	else:
		_walking = false
	
	if _walking:
		_active_animation = "Walk" + _dir
		if _dir == "left":
			velocity.x = -_speed
		else:
			velocity.x = _speed
	else:
		_active_animation = "Idle" + _dir
		velocity.x = 0
	_active_suit.play(_active_animation)

func _death():
	SignalBus.player_pos.emit(self.main_camera.get_screen_center_position())
	GameManager.player_suit = "basic_suit"
	velocity = Vector2(0,0)
	_active_suit.play("Death")
	_health = 0
	GameManager.create_timer(self, 0.5, _death_timeout)

func _death_timeout():
	_death_fall = true
	hitbox.queue_free()
	ground_coll.queue_free()
	velocity.y = -_jump_velocity / _kill_bounce_decrease
	main_camera.enabled = false
	GameManager.create_timer(self, 3.0, _restart)

func _restart():
	SignalBus.emit_signal("reset")

# CHANGE AS SUITS ARE ADDED
func _collect(_amount, _value):
	if _amount is int:
		pass
	else:
		if _value <= _suit_val:
			return
		else:
			match(_value):
				2:
					_suit_val = 2
					match(_amount):
						"better_suit":
							_active_suit = _better_suit
				3:
					_suit_val = 3
					match(_amount):
						"jump_suit":
							_active_suit = _jump_suit
			_toggle_anims(_active_suit)

func cam_pos():
	return self.main_camera.get_screen_center_position()

func _toggle_anims(_current):
	for _child in get_children():
		if _child is AnimatedSprite2D:
			if _child == _current:
				_child.show()
			else:
				_child.hide()

func get_score():
	return score
