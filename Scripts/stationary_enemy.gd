extends CharacterBody2D

# Player Character
@onready var player: CharacterBody2D = $"../Player"
@onready var kill_box: Area2D = $kill_box
@onready var death_timer: Timer = $death_timer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()


func _on_kill_box_body_entered(body: CharacterBody2D) -> void:
	if body == player:
		print("Enemy damage player signal")
		player.emit_signal("hit_player")

var timer_started: bool = false
func _on_death_box_body_entered(body: CharacterBody2D) -> void:
	if body == player:
		print("Player killed enemy")
		kill_box.queue_free()
		player.emit_signal("kill_bounce")
		if (!timer_started):
			death_timer.start()
			timer_started = true


func _on_death_timer_timeout() -> void:
	self.queue_free()
