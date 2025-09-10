extends CharacterBody2D

@export var _left_block: bool
@export var _middle_block: bool
@export var _right_block: bool
@export var _itemName: String

@onready var _sprite = $AnimatedSprite2D

var _hit = false
var _time_to_pop_out = 5
var _can_fall = false
var _can_move = false
var hitbox = null

func _ready():
	$Player_Detector.connect("body_entered", _on_detector_hit)
	if not _oneSelect():
		_left_block = false
		_middle_block = false
		_right_block = false
	
	if _left_block:
		_sprite.play("LeftBlock")
	elif _middle_block:
		_sprite.play("MiddleBlock")
	elif _right_block:
		_sprite.play("RightBlock")
	else:
		_sprite.play("SoloBlock")
	
	if _itemName not in ItemDB.ITEMS:
		_itemName = ""
	
	if _itemName == "":
		self.queue_free()

func _on_detector_hit(_body):
	if _body.is_in_group("player") and not _hit:
		_hit = true
		var _item_instance = null
		var item = null
		item = ItemDB.ITEMS[_itemName]
		if GameManager.player_suit == "basic_suit" and item.has("suit_value"):
			item = ItemDB.ITEMS["better_suit_item"]
			var _item_scene = load(item["path"])
			print("Item: ", item)
			_item_instance = _item_scene.instantiate()
		else:
			var _item_scene = load(item["path"])
			print("Item: ", item)
			_item_instance = _item_scene.instantiate()
		if "fallable" in _item_instance:
			_can_fall = item["fallable"]
		if "mobile" in _item_instance:
			_can_move = item["mobile"]
		if "suit_type" in _item_instance:
			_item_instance.suit_type = item["suit_type"]
			_item_instance.suit_value = item["suit_value"]
		get_tree().current_scene.add_child(_item_instance)
		if _item_instance.has_node("enemy_hit_box"):
			hitbox = _item_instance.get_node("enemy_hit_box")
		hitbox.disabled = true
		_item_instance.global_position = self.global_position
		_animate_pop_out(_item_instance)
		GameManager.create_timer(self, 5, _delete)

func _delete():
	self.queue_free()

var tween
func _animate_pop_out(node):
	tween = create_tween()
	tween.tween_property(node, "global_position", node.global_position + Vector2(0,-128), _time_to_pop_out).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	hitbox.disabled = false
	if is_instance_valid(node):
		node.mobile = _can_move
		node.fallable = _can_fall

func _on_item_collected():
	if tween:
		tween.kill()
	if is_instance_valid(self):
		self.queue_free()

func _oneSelect():
	if _left_block and !_right_block and !_middle_block:
		return true
	elif !_left_block and _right_block and !_middle_block:
		return true
	elif !_left_block and !_right_block and _middle_block:
		return true
	else:
		return false
