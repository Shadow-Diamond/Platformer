extends CharacterBody2D

@export var _speed : int
@export var _jump_velocity : int
@export var _kill_bounce_decrease : int

@onready var _main_camera: Camera2D = $Camera2D
@export var _mc_left_marg: float
@export var _mc_top_marg: float
@export var _mc_right_marg: float
@export var _mc_bottom_marg: float
@export var _mc_upper_bound: int = 0
