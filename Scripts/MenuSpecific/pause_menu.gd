extends Control

@onready var resume: Button = $MarginContainer/VBoxContainer/Resume
@onready var save: Button = $MarginContainer/VBoxContainer/Save
@onready var quit: Button = $MarginContainer/VBoxContainer/Quit
@onready var dataText = $DataText

func _ready():
	set_process_mode(Node.PROCESS_MODE_ALWAYS) 
	dataText.hide()

func _on_resume():
	GameManager.unpause()

func _on_save():
	GameManager.save_status()
	dataText.show()
	GameManager.create_timer(self, 2.5, _hide_save)

func _on_quit_level():
	GameManager.quit_level()

func _on_quit_game():
	get_tree().quit()

func _hide_save():
	dataText.hide()
