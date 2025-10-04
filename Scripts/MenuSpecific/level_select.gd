extends Node2D

@onready var score_box: TextEdit = $ScoreBox
@onready var virellia = $Virellia
@onready var chromatic_bonuses = $Chromatic_Bonuses

@onready var back_button: Button = $BackButton
@onready var select_button: Button = $SelectButton
@onready var camera = $Camera2D
@onready var planets = []
@onready var num_levels_comp
@onready var num_levels_per_planet
@onready var nec_text: TextEdit = $not_enough_currency
@onready var lvl1_button: Button = $Lvl1
@onready var lvl2_button: Button = $Lvl2
@onready var lvl3_button: Button = $Lvl3
@onready var lvl4_button: Button = $Lvl4
@onready var lvl5_button: Button = $Lvl5

var cur_planet = null
var cur_planet_index = 0
var planet_list_size = null


func _ready():
	nec_text.visible = false
	planets.append(virellia)
	planets.append(chromatic_bonuses)
	cur_planet = planets[0]
	planet_list_size = planets.size()
	num_levels_comp = GameManager.get_num_levels_available()
	num_levels_per_planet = GameManager.get_num_levels_max()
	
	for planet in planets:
		if planet != cur_planet:
			planet.get_node("Background").visible = false
			planet.get_node("Background2").visible = false

var distance = 0
func _physics_process(_delta):
	if GameManager.purchased_planet[cur_planet.name] == false:
		select_button.text = "Purchase: " + str(GameManager.purchase_price[cur_planet.name])
	else:
		select_button.text = "Select"
	if Input.is_action_just_pressed("Right"):
		var newIndex = cur_planet_index + 1
		if newIndex < planet_list_size:
			cur_planet.get_node("Background").visible = false
			cur_planet.get_node("Background2").visible = false
			cur_planet_index = newIndex
			cur_planet = planets[newIndex]
			distance = cur_planet.position.x - camera.position.x
			nec_text.position.x += distance
			camera.position.x += distance
			score_box.position.x += distance
			select_button.position.x += distance
			back_button.position.x += distance
			cur_planet.get_node("Background").visible = true
			cur_planet.get_node("Background2").visible = true
	elif Input.is_action_just_pressed("Left"):
		var newIndex = cur_planet_index - 1
		if newIndex >= 0:
			cur_planet.get_node("Background").visible = false
			cur_planet.get_node("Background2").visible = false
			cur_planet_index = newIndex
			cur_planet = planets[newIndex]
			distance = cur_planet.position.x - camera.position.x
			nec_text.position.x += distance
			camera.position.x += distance
			score_box.position.x += distance
			select_button.position.x += distance
			back_button.position.x += distance
			cur_planet.get_node("Background").visible = true
			cur_planet.get_node("Background2").visible = true

var num_levels
var addedDist
func _on_select_button_pressed():
	if GameManager.purchased_planet[cur_planet.name] == false:
		var attempt = GameManager.purchase_planet(cur_planet.name)
		if attempt == false:
			nec_text.visible = true
			GameManager.create_timer(self, 5, hide_nec)
	else:
		if distance < 0:
			addedDist = 0
		else:
			addedDist = distance
		camera.global_position.y += 1080
		score_box.global_position.y += 1080
		num_levels = num_levels_comp[str(cur_planet.name)]+1
		if num_levels > num_levels_per_planet[str(cur_planet.name)]:
			num_levels = num_levels_per_planet[str(cur_planet.name)]
		match(num_levels):
			1:
				lvl1_button.position = Vector2(-136 + addedDist,1038)
				lvl2_button.position = Vector2(0,2000)
				lvl3_button.position = Vector2(0,2000)
				lvl4_button.position = Vector2(0,2000)
				lvl5_button.position = Vector2(0,2000)
			2:
				lvl1_button.position = Vector2(-296 + addedDist,1038)
				lvl2_button.position = Vector2(24 + addedDist,1038)
				lvl3_button.position = Vector2(0,2000)
				lvl4_button.position = Vector2(0,2000)
				lvl5_button.position = Vector2(0,2000)
			3:
				lvl1_button.position = Vector2(-456 + addedDist, 1038)
				lvl2_button.position = Vector2(-136 + addedDist, 1038)
				lvl3_button.position = Vector2(184 + addedDist, 1038)
				lvl4_button.position = Vector2(0,2000)
				lvl5_button.position = Vector2(0,2000)
			4:
				lvl1_button.position = Vector2(-616 + addedDist,1038)
				lvl2_button.position = Vector2(-296 + addedDist,1038)
				lvl3_button.position = Vector2(24 + addedDist,1038)
				lvl4_button.position = Vector2(344 + addedDist,1038)
				lvl5_button.position = Vector2(0,2000)
			5:
				lvl1_button.position = Vector2(-776 + addedDist, 1038)
				lvl2_button.position = Vector2(-456 + addedDist, 1038)
				lvl3_button.position = Vector2(-136 + addedDist, 1038)
				lvl4_button.position = Vector2(184 + addedDist, 1038)
				lvl5_button.position = Vector2(504 + addedDist, 1038)
		if cur_planet == virellia:
			lvl1_button.text = "Tutorial"
		elif cur_planet == chromatic_bonuses:
			lvl1_button.text = "Virellia"
		else:
			lvl1_button.text = "Level 1"


func _on_back_button_pressed() -> void:
	camera.global_position.y -= 1080
	score_box.global_position.y -= 1080


func _on_lvl_1_pressed() -> void:
	print(GameManager.Levels[str(cur_planet.name)][1])
	GameManager.load_scene((GameManager.Levels[str(cur_planet.name)][1]))


func _on_lvl_2_pressed() -> void:
	GameManager.load_scene((GameManager.Levels[str(cur_planet.name)][2]))

func _on_lvl_3_pressed() -> void:
	GameManager.load_scene((GameManager.Levels[str(cur_planet.name)][3]))

func hide_nec():
	nec_text.visible = false
