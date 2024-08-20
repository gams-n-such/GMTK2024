class_name Controller
extends Node

var _controlled_unit : Node = null
@export var controlled_unit : Node:
	get:
		return _controlled_unit
	set(new_unit):
		_controlled_unit = new_unit
		_update_input_target()

var _input_target : Node = null
var _input_target_2d : Node2D:
	get:
		return _input_target as Node2D

func _update_input_target() -> void:
	if controlled_unit:
		_input_target = controlled_unit.get_input_target()
	else:
		_input_target = null

func _ready() -> void:
	_update_input_target()

func _process(delta: float) -> void:
	if _input_target:
		_input_target.move_to(_get_move_direction(), _get_aim_target())

func _get_move_direction() -> Vector2:
	return Vector2.RIGHT

func _get_aim_target() -> Vector2:
	return Vector2.ZERO
