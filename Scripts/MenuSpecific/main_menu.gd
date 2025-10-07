extends Node

@onready var dataText = $MainMenuUI/DataText
var disable_quit = false

func _ready():
	dataText.hide()
	if GameManager.osType == "Web":
		disable_quit = true

func _on_play():
	var scene = GameManager.Levels["Misc"]["LevelSelect"]
	GameManager.load_scene(scene)

func _on_load():
	dataText.show()
	GameManager.load_status()
	GameManager.create_timer(self, 2.5, _hide_text)

func _on_quit():
	if not disable_quit:
		get_tree().quit()

func _hide_text():
	dataText.hide()
