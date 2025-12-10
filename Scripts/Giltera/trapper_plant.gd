extends CharacterBody2D
								# Closed to Open
@onready var _left_arm = $LeftArm #2 to -90
@onready var _right_arm = $RightArm #-2 to 90
@onready var _back_arm = $BackArm
@onready var _top_cover = $TopCover
@onready var _trap_area = $TrapArea
@onready var _release_area = $ReleaseArea
@onready var _left_arm_sb = $LeftWallSB
@onready var _right_arm_sb = $RightWallSB
@onready var _cover_sb = $RoofSB
@onready var _left_arm_col = $LeftWallSB/LeftWall
@onready var _right_arm_col = $RightWallSB/RightWall
@onready var _cover_col = $RoofSB/Roof
@onready var _bottom: AnimatedSprite2D = $Bottom
@onready var _right_arm_sprite: AnimatedSprite2D = $RightArm/RightArmSprite
@onready var _left_arm_sprite: AnimatedSprite2D = $LeftArm/LeftArmSprite

@export var _max_hit : int = 10
var _not_closed = true
var _num_times_hit = 0

func _ready():
	_left_arm_sprite.play("default")
	_right_arm_sprite.play("default")
	_back_arm.play("default")
	_top_cover.play("default")
	_bottom.play("default")
	_trap_area.body_entered.connect(_trap_player)
	_release_area.body_entered.connect(_release_player)
	_back_arm.hide()
	_top_cover.hide()
	_left_arm_sb.visible = false
	_left_arm_col.set_deferred("disabled", true)
	_right_arm_sb.visible = false
	_right_arm_col.set_deferred("disabled", true)
	_cover_sb.visible = false
	_cover_col.set_deferred("disabled", true)
	_release_area.monitoring = false

func _trap_player(object):
	if object.is_in_group("player") && _not_closed:
		_not_closed = false
		_left_arm.rotate(1.6057)
		_right_arm.rotate(-1.6057)
		_top_cover.show()
		_back_arm.show()
		_left_arm_sb.visible = true
		_left_arm_col.set_deferred("disabled", false)
		_right_arm_sb.visible = true
		_right_arm_col.set_deferred("disabled", false)
		_cover_sb.visible = true
		_cover_col.set_deferred("disabled", false)
		_release_area.monitoring = true
		SignalBus.trapper_plant_snatch.emit()

func _release_player(object):
	_num_times_hit += 1
	_damage_flicker_on()

func _physics_process(delta: float) -> void:
	if _num_times_hit >= _max_hit && not _not_closed:
		_release_area.monitoring = false
		_left_arm_sb.visible = false
		_left_arm_col.set_deferred("disabled", true)
		_right_arm_sb.visible = false
		_right_arm_col.set_deferred("disabled", true)
		_cover_sb.visible = false
		_cover_col.set_deferred("disabled", true)
		_top_cover.hide()
		_back_arm.hide()
		_left_arm.rotate(-1.6057)
		_right_arm.rotate(1.6057)
		_not_closed = true
		_num_times_hit = 0

func _damage_flicker_on():
	if _num_times_hit > _max_hit - 1:
		return
	_left_arm_sprite.play("damage")
	_right_arm_sprite.play("damage")
	_back_arm.play("damage")
	_top_cover.play("damage")
	_bottom.play("damage")
	GameManager.create_timer(self, .5, _damage_flicker_off)

func _damage_flicker_off():
	_left_arm_sprite.play("default")
	_right_arm_sprite.play("default")
	_back_arm.play("default")
	_top_cover.play("default")
	_bottom.play("default")
