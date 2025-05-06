extends CharacterBody2D

@export var left_block: bool
@export var middle_block: bool
@export var right_block: bool
@export var itemName: String

@onready var sprite = $AnimatedSprite2D
@onready var deletion_timer = $DeletionTimer

@onready var player = $"../Player"

func _ready():
	self.z_index = 1

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
	if body == player:
		var item = ItemDB.ITEMS[itemName]
		var itemScene = load(item["path"])
		var item_instance = itemScene.instantiate()
		
		if "stationary" in item_instance:
			item_instance.stationary = item["stationary"]
			if "fallable" in item_instance:
				item_instance.fallable = item["fallable"]
			item_instance.behavior = false
		item_instance.global_position = self.global_position
		item_instance.z_index = -1
		get_tree().current_scene.add_child(item_instance)
		animate_pop_out(item_instance)
		deletion_timer.start()

func _on_deletion_timer_timeout():
	self.queue_free()

func animate_pop_out(node):
	var tween = create_tween()
	tween.tween_property(node, "global_position", node.global_position + Vector2(0,-128), 5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	node.start_behavior()
