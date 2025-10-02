extends Control

@onready var resume: Button = $MarginContainer/VBoxContainer/Resume
@onready var save: Button = $MarginContainer/VBoxContainer/Save
@onready var quit: Button = $MarginContainer/VBoxContainer/Quit

func _ready():
	set_process_mode(Node.PROCESS_MODE_ALWAYS) 

func _on_resume():
	GameManager.unpause()

func _on_save():
	GameManager.save_status()

func _on_quit():
	GameManager.quit_level()
