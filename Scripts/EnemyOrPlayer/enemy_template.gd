extends CharacterBody2D

@onready var _sprite : AnimatedSprite2D = $EnemySprite
@onready var _ground_detector_1 : RayCast2D = $GroundDetector1
@onready var _ground_detector_2 : RayCast2D = $GroundDetector2
@onready var _player_kill_box  : Area2D = $PKillBox
@onready var _self_kill_box : Area2D = $SKillBox
@onready var _self_hitbox : CollisionShape2D = $enemy_hit_box

@export var mobile : bool = false
@export var fallable : bool = false

var _speed = 0 # Change in scripts inheriting this file

var _dead : bool = false
var _flip_val : bool = true
var _curr_pos : Vector2 = Vector2.ZERO
var _prev_pos : Vector2 = Vector2.ZERO
var _flip_mult : int = 1
var _flip_delay : bool = false
var _has_gravity : bool = true
var active : bool = true

func _ready():
	_self_hitbox.disabled = false
	# Intra-Script Signals
	_player_kill_box.body_entered.connect(_attempt_to_hurt_player)
	_self_kill_box.body_entered.connect(_enemy_death)
	
	# Inter-Script Signals

func _physics_process(delta: float) -> void:
	_move(delta)

# When the player touches this enemy in a spot that would kill them
func _attempt_to_hurt_player(object):
	if _dead:
		return
	
	if object.is_in_group("player"):
		print(self.name, " hit Player")
		_self_kill_box.monitoring = false
		SignalBus.hurt_player.emit()
	elif object.is_in_group("enemies"):
		_move_flip(null)

# When the enemy this script is on dies
func _enemy_death(object): 
	if _dead:
		return
	
	if object.is_in_group("player"):
		_dead = true
		print(self.name, " killed by Player")
		SignalBus.bounce.emit()
		SignalBus.e_death.emit(1)
		GameManager.create_timer(self, 1, _on_self_death_delay_timeout)

# Calls both falling and movement functions depending on variables
func _move(delta):
	if _has_gravity:
		_fall(delta)
	
	if mobile and !_dead and active:
		_movement()
	else:
		print("hello")
		_sprite.play("Idle")
		velocity.x = 0
	
	move_and_slide()

# Function for anything to deal with falling
func _fall(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

# Function for all horizontal movement
func _movement():
	# Animation and horizontal positioning
	_sprite.play("Walking")
	_sprite.flip_h = _flip_val
	velocity.x = _speed * _flip_mult
	
	# Flipping enemy when stuck or hitting a wall
	_curr_pos = self.position
	var _stuck = false
	if _prev_pos != null:
		_stuck = _curr_pos.distance_to(_prev_pos) < 0.5
	var _no_ground = !_ground_detector_1.is_colliding() or !_ground_detector_2.is_colliding()
	var _should_flip = _no_ground and !fallable
	if (_stuck or _should_flip) and not _flip_delay:
		_move_flip("move")
	_prev_pos = _curr_pos

func _move_flip(called):
	_flip_mult *= -1
	_flip_val = !_flip_val
	if called == "move":
		GameManager.create_timer(self, 1, _on_flip_delay_timer_timeout)
		_flip_delay = true

func _on_self_death_delay_timeout():
	self.queue_free()

func _on_flip_delay_timer_timeout():
	_flip_delay = false
