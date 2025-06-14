extends CharacterBody2D

@export var Speed : float
@export var Jump_Velocity : float
@export var kill_bounce_decrease: int

@onready var main_camera: Camera2D = $Camera2D
@export var mc_left_marg: float
@export var mc_top_marg: float
@export var mc_right_marg: float
@export var mc_bottom_marg: float

@onready var death_delay: Timer = $death_delay
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var restart_timer = $restart_timer
@onready var hit_timer: Timer = $hit_timer
@onready var basic_spacesuit: AnimatedSprite2D = $basic_spacesuit
@onready var better_spacesuit: AnimatedSprite2D = $better_spacesuit

var activeSprite: AnimatedSprite2D
var dead = false
var health = 1
var death_delay_passed: bool = false
var player_death: bool = false
var hit = false
var dir = "right"
var ability = "none"

signal hit_player
signal kill_bounce
signal kill_player
signal power_up

func _ready() -> void:
	connect("power_up", Callable(self, "_power_up"))
	connect("hit_player", Callable(self, "_on_hit_player"))
	connect("kill_bounce", Callable(self, "_on_kill_bounce"))
	connect("kill_player", Callable(self, "_on_kill_player"))
	if mc_bottom_marg >= 0 || mc_bottom_marg <= 1:
		main_camera.drag_bottom_margin = mc_bottom_marg
	if mc_left_marg >= 0 || mc_left_marg <= 1:
		main_camera.drag_left_margin = mc_left_marg
	if mc_right_marg >= 0 || mc_right_marg <= 1:
		main_camera.drag_right_margin = mc_right_marg
	if mc_top_marg >= 0 || mc_top_marg <= 1:
		main_camera.drag_top_margin = mc_top_marg
	activeSprite = basic_spacesuit
	better_spacesuit.hide()

func _physics_process(delta: float) -> void:
	
	if not dead:
		# Handles the gravity of the Character
		if not is_on_floor():
			velocity += get_gravity() * delta
			# activeSprite.play("Falling")
		
		if is_on_floor() and Input.is_action_just_pressed("Up"):
			velocity.y = -Jump_Velocity
		
		# Handles the X-axis movement of the Character
		if Input.is_action_pressed("Left"):
			activeSprite.play("WalkLeft")
			dir = "left"
			velocity.x = -Speed
		elif Input.is_action_pressed("Right"):
			activeSprite.play("WalkRight")
			dir = "right"
			velocity.x = Speed
		else:
			velocity.x = 0
			if dir == "left":
				activeSprite.play("IdleLeft")
			elif dir == "right":
				activeSprite.play("IdleRight")
	elif not death_delay_passed:
		velocity.x = 0
		velocity.y = 0
	else:
		if !player_death:
			collision_shape_2d.queue_free()
			player_death = true
			velocity.y = -Jump_Velocity/kill_bounce_decrease
			main_camera.enabled = false
			restart_timer.start()
		velocity += get_gravity() * delta
		
	
	move_and_slide()

func _on_hit_player():
	print("Damage signal received")
	if not hit:
		hit_timer.start()
		hit = true
		match(health):
			1:
				dead = true
				health -= 1
				death_delay.start()
				# activeSprite.play("Death")
			2:
				health -= 1
				activeSprite = basic_spacesuit
				better_spacesuit.hide()
			3:
				health -= 1
				activeSprite = better_spacesuit
				basic_spacesuit.hide()
		activeSprite.show()

func _on_kill_bounce():
	velocity.y = -Jump_Velocity/kill_bounce_decrease


func _on_death_delay_timeout() -> void:
	death_delay_passed = true


func restart():
	if (GameManager.remaining_lives - 1) > 0:
		GameManager.load_scene(GameManager.current_level)
		GameManager.remaining_lives -= 1
	else:
		var level = GameManager.Levels["Misc"]["LevelSelect"]
		GameManager.load_scene(level)

func death():
	return player_death

func cam_pos():
	return self.main_camera.get_screen_center_position()

func _on_kill_player():
	if !dead:
		health = 0
		dead = true
		death_delay.start()

func _power_up(power_up_name):
	if power_up_name == "better_suit":
		activeSprite = better_spacesuit
		if health < 2:
			basic_spacesuit.hide()
			health_gain()
	activeSprite.show()

func health_gain():
	health += 1


func _on_hit_timer_timeout() -> void:
	hit = false
