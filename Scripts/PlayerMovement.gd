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
@onready var hurt_box: Area2D = $HurtBox
@onready var restart_timer = $restart_timer
@onready var hit_timer: Timer = $hit_timer
@onready var basic_spacesuit: AnimatedSprite2D = $basic_spacesuit
@onready var better_spacesuit: AnimatedSprite2D = $better_spacesuit
@onready var ground_collision: CollisionShape2D = $GroundCollision

var tap_jump = Jump_Velocity / 10
var activeSprite: AnimatedSprite2D
var dead = false
var health = 1
var death_delay_passed: bool = false
var player_death: bool = false
var hit = false
var dir = "right"
var ability = "none"
var walk_pause : bool = false
var score : int = 0
var jump_held : bool = false

signal hit_player
signal kill_bounce
signal kill_player
signal power_up
signal collectable
signal score_sig

func _ready() -> void:
	connect("power_up", Callable(self, "_power_up"))
	connect("hit_player", Callable(self, "_on_hit_player"))
	connect("kill_bounce", Callable(self, "_on_kill_bounce"))
	connect("kill_player", Callable(self, "_on_kill_player"))
	connect("collectable", Callable(self, "_on_collect_currency"))
	connect("score_sig", Callable(self,"_send_score"))
	if mc_bottom_marg >= 0 || mc_bottom_marg <= 1:
		main_camera.drag_bottom_margin = mc_bottom_marg
	if mc_left_marg >= 0 || mc_left_marg <= 1:
		main_camera.drag_left_margin = mc_left_marg
	if mc_right_marg >= 0 || mc_right_marg <= 1:
		main_camera.drag_right_margin = mc_right_marg
	if mc_top_marg >= 0 || mc_top_marg <= 1:
		main_camera.drag_top_margin = mc_top_marg
	match(GameManager.player_suit):
		"basic_suit":
			better_spacesuit.hide()
			activeSprite = basic_spacesuit
		"better_suit":
			health = 2
			basic_spacesuit.hide()
			activeSprite = better_spacesuit

func _physics_process(delta: float) -> void:
	
	if not dead:
		# Handles the gravity of the Character
		if not is_on_floor():
			velocity += get_gravity() * delta
			var jumpAnim = "Jump" + dir
			activeSprite.play(jumpAnim)
			walk_pause = true
		
		if is_on_floor():
			walk_pause = false
		
		if is_on_floor() and Input.is_action_just_pressed("Up"):
			velocity.y = -Jump_Velocity
			jump_held = true
		
		if Input.is_action_just_released("Up") and jump_held:
			jump_held = false
			velocity.y *= .5
		
		# Handles the X-axis movement of the Character
		if Input.is_action_pressed("Left"):
			if !walk_pause:
				activeSprite.play("WalkLeft")
			dir = "left"
			velocity.x = -Speed
		elif Input.is_action_pressed("Right"):
			if !walk_pause:
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
			hurt_box.queue_free()
			ground_collision.queue_free()
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
				activeSprite.play("Death")
			2:
				health -= 1
				activeSprite = basic_spacesuit
				better_spacesuit.hide()
				GameManager.player_suit = "basic_suit"
			3:
				health -= 1
				activeSprite = better_spacesuit
				basic_spacesuit.hide()
				GameManager.player_suit = "better_suit"
		activeSprite.show()

func _on_kill_bounce():
	velocity.y = -Jump_Velocity/kill_bounce_decrease
	score += 1


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
		GameManager.player_suit = "basic_suit"
		activeSprite.play("Death")
		health = 0
		dead = true
		death_delay.start()

func _power_up(power_up_name):
	if power_up_name == "better_suit":
		GameManager.player_suit = "better_suit"
		activeSprite = better_spacesuit
		if health < 2:
			basic_spacesuit.hide()
			health_gain()
	activeSprite.show()

func health_gain():
	health += 1


func _on_hit_timer_timeout() -> void:
	hit = false

func _on_collect_currency():
	score += 10

func _send_score():
	GameManager.currency += score

func _get_score():
	return score
