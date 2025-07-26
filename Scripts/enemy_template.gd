extends CharacterBody2D

@onready var _sprite : AnimatedSprite2D = $EnemySprite
@onready var _ground_detector_1 : RayCast2D = $GroundDetector1
@onready var _ground_detector_2 : RayCast2D = $GroundDetector2
@onready var _player_kill_box  : Area2D = $PKillBox
@onready var _self_kill_box : Area2D = $SKillBox
@onready var _self_death_delay : Timer = $DeathDelay

@export var _mobile : bool = false
@export var _fallable : bool = false

var _speed = 0 # Change in scripts inheriting this file

var _dead : bool = false
var _flip_val : bool = false
var _curr_pos : Vector2 = Vector2.ZERO
var _prev_pos : Vector2 = Vector2.ZERO
var _flip_mult = -1

func _ready():
	_player_kill_box.area_entered.connect(_attempt_to_hurt_player)
	_self_kill_box.area_entered.connect(_enemy_death)

func _physics_process(delta: float) -> void:
	_move(delta)

# When the player touches this enemy in a spot that would kill them
func _attempt_to_hurt_player(object):
	if _dead:
		return
	
	if object.is_in_group("player"):
		_self_kill_box.monitoring = false
		SignalBus.hurt_player.emit(self)
	elif object.is_in_group("enemies"):
		_move_flip()

# When the enemy this script is on dies
func _enemy_death(): 
	if _dead:
		return
	_dead = true
	SignalBus.bounce.emit()
	SignalBus.e_death.emit(self)
	_self_death_delay.start()

# Calls both falling and movement functions depending on variables
func _move(delta):
	if _fallable:
		_fall(delta)
	
	if _mobile and !_dead:
		_movement(delta)
	else:
		_sprite.play("Idle")
		velocity.x = 0

# Function for anything to deal with falling
func _fall(delta):
	if not is_on_floor():
		velocity += get_gravity() + delta

# Function for all horizontal movement
func _movement(delta):
	# Animation and horizontal positioning
	_sprite.play("Walking")
	_sprite.flip_h = _flip_val
	velocity.x = delta * _speed * _flip_mult
	
	# Flipping enemy when stuck or hitting a wall
	_curr_pos = self.position
	var _stuck = _curr_pos == _prev_pos
	var _no_ground = !_ground_detector_1.is_colliding() or !_ground_detector_2.is_colliding()
	var _should_flip = _no_ground and !_fallable
	if _stuck or _should_flip:
		_move_flip()
	_prev_pos = _curr_pos

func _move_flip():
	_flip_mult *= -1
	_flip_val = !_flip_val

func _on_self_death_delay_timeout():
	self.queue_free()
