@tool
extends Node2D

func _ready() -> void:
	_update_boundaries()

var _arena_size : Vector2 = Vector2(1000.0, 1000.0)
@export var arena_size : Vector2:
	get:
		return _arena_size
	set(new_size):
		_arena_size = new_size
		if is_node_ready():
			_update_boundaries()

var _wall_thickness : float = 20.0
@export var wall_thickness : float:
	get:
		return _wall_thickness
	set(new_thickness):
		_wall_thickness = new_thickness
		if is_node_ready():
			_update_boundaries()

func _get_shape_res(collision : CollisionShape2D) -> RectangleShape2D:
	return collision.shape as RectangleShape2D

func _update_boundaries() -> void:
	# Horizontal and vertical lines share their resources
	_get_shape_res($LeftWall/Shape).size.y = arena_size.y
	#_get_shape_res($RightWall/Shape).size.y = arena_size.y
	_get_shape_res($UpWall/Shape).size.x = arena_size.x
	#_get_shape_res($DownWall/Shape).size.x = arena_size.x
	var half_size = arena_size / 2.0
	$LeftWall.position = Vector2(-half_size.x, 0)
	$RightWall.position = Vector2(half_size.x, 0)
	$UpWall.position = Vector2(0, -half_size.y)
	$DownWall.position = Vector2(0, half_size.y)
	# Horizontal and vertical lines share their resources
	_get_shape_res($LeftWall/Shape).size.x = wall_thickness
	#_get_shape_res($RightWall/Shape).size.x = wall_thickness
	_get_shape_res($UpWall/Shape).size.y = wall_thickness
	#_get_shape_res($DownWall/Shape).size.y = wall_thickness
	var half_thickness = wall_thickness / 2.0
	$LeftWall/Shape.position = Vector2(-half_thickness, 0)
	$RightWall/Shape.position = Vector2(half_thickness, 0)
	$UpWall/Shape.position = Vector2(0, -half_thickness)
	$DownWall/Shape.position = Vector2(0, half_thickness)
	pass
