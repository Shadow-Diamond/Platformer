extends CharacterBody2D

@export var left_block: bool
@export var middle_block: bool
@export var right_block: bool
@export var itemName: String
@export var spawning_suit_power: bool

@onready var sprite = $AnimatedSprite2D
@onready var deletion_timer = $DeletionTimer

@onready var player = $"../Player"

var hit = false
var time_to_pop_out = 5

func _ready():
	self.z_index = 5

func _physics_process(_delta):
	if left_block and right_block or left_block and middle_block or right_block and middle_block or left_block and middle_block and right_block:
		left_block = false
		middle_block = false
		right_block = false
	
	if left_block:
		sprite.play("LeftBlock")
	elif middle_block:
		sprite.play("MiddleBlock")
	elif right_block:
		sprite.play("RightBlock")
	else:
		sprite.play("SoloBlock")
	
	if itemName not in ItemDB.ITEMS:
		itemName = ""
	
	if itemName == "":
		self.queue_free()


func _on_player_detector_body_entered(body):
	var item_instance = null
	var item = null
	if body == player and not hit:
		hit = true
		if GameManager.player_suit == "basic_suit" and spawning_suit_power:
			item = ItemDB.ITEMS["better_suit_item"]
			var itemScene = load(item["path"])
			item_instance = itemScene.instantiate()
		else:
			item = ItemDB.ITEMS[itemName]
			var itemScene = load(item["path"])
			print("Item: ", item)
			print("Path: ", item["path"])
			print("Loaded: ", itemScene)
			item_instance = itemScene.instantiate()
		item_instance.z_as_relative = false
		item_instance.z_index = -1
		if "stationary" in item_instance:
			item_instance.stationary = item["stationary"]
			if "fallable" in item_instance:
				item_instance.fallable = item["fallable"]
			item_instance.behavior = false
		if "suit_type" in item_instance:
			item_instance.suit_type = item["suit_type"]
		if item_instance.has_signal("collected"):
			item_instance.collected.connect(_on_item_collected)
		item_instance.global_position = self.global_position
		get_tree().current_scene.add_child(item_instance)
		animate_pop_out(item_instance)
		deletion_timer.start()

func _on_deletion_timer_timeout():
	self.queue_free()

var tween
func animate_pop_out(node):
	tween = create_tween()
	tween.tween_property(node, "global_position", node.global_position + Vector2(0,-128), time_to_pop_out).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	if is_instance_valid(node):
		if node.has_method("start_behavior"):
			node.start_behavior()

func _on_item_collected():
	if tween:
		tween.kill()
	if is_instance_valid(self):
		self.queue_free()
