extends Control

@onready var dataText = $DataText
var disable_quit = false

func _ready():
	set_process_mode(Node.PROCESS_MODE_ALWAYS) 
	dataText.hide()
	if GameManager.osType == "Web":
		disable_quit = true

func _on_resume():
	GameManager.unpause()

func _on_save():
	if not disable_quit:
		GameManager.save_status()
		dataText.show()
		GameManager.create_timer(self, 2.5, _hide_save)

func _on_quit_level():
	GameManager.quit_level()

func _on_quit_game():
	if not disable_quit:
		get_tree().quit()

func _hide_save():
	dataText.hide()
