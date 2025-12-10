extends CharacterBody2D

@onready var _sprite : AnimatedSprite2D = $EnemySprite
@onready var _ground_detector_1 : RayCast2D = $GroundDetector1
@onready var _ground_detector_2 : RayCast2D = $GroundDetector2
@onready var _player_kill_box  : Area2D = $PKillBox
@onready var _self_kill_box : Area2D = $SKillBox
@onready var _self_hitbox : CollisionShape2D = $enemy_hit_box
@onready var _ray_cast_vision : RayCast2D = $Vision_Ray

var _speed = 0 # Change in scripts inheriting this file

var _dead : bool = false
var active : bool = true
var _player_node
var _walk_val = false

func _ready():
	_self_hitbox.disabled = false
	_player_node = get_tree().get_nodes_in_group("PlayerChar")
	_player_node = _player_node[0]
	# Intra-Script Signals
	_player_kill_box.body_entered.connect(_attempt_to_hurt_player)
	_self_kill_box.body_entered.connect(_enemy_death)
	
	# Inter-Script Signals

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	if _player_node:
		var _dir_to_player = global_position.direction_to(_player_node.global_position)
		_ray_cast_vision.target_position = _dir_to_player * 1000
		var _seen_coll = _ray_cast_vision.get_collider()
		if _seen_coll != null and _seen_coll.is_in_group("player"):
			_move(delta, _player_node)
		else:
			_move(delta, null)

# When the player touches this enemy in a spot that would kill them
func _attempt_to_hurt_player(object):
	if _dead:
		return
	
	if object.is_in_group("player"):
		print(self.name, " hit Player")
		_self_kill_box.monitoring = false
		#SignalBus.hurt_player.emit()

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
func _move(delta, target):
	if target == null and _walk_val == false:
		_walk_val = true
		var _walk_time = randi_range(1,5)
		var _walk_dir = randi_range(1,2)
		GameManager.create_timer(self, _walk_time, _idle)
		if _walk_dir == 1:
			_sprite.flip_h = true
			_sprite.play("walk")
			velocity.x = -_speed
		else:
			_sprite.flip_h = false
			_sprite.play("walk")
			velocity.x = _speed
	else:
		pass
	move_and_slide()

func _idle():
	velocity.x = 0
	_sprite.play("idle")
	var _idle_time = randi_range(1,5)
	GameManager.create_timer(self, _idle_time, _reset_walk)

func _reset_walk():
	_walk_val = true

# Function for anything to deal with falling
func _fall(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

# Function for all horizontal movement
func _movement():
	pass

func _on_self_death_delay_timeout():
	self.queue_free()
