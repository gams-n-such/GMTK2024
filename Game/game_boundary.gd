@tool
extends Node2D

@export var arena_size : Vector2:
	get:
		return Vector2(_get_shape_res($UpWall/Shape).size.x, _get_shape_res($LeftWall/Shape).size.y)
	set(new_size):
		# Horizontal and vertical lines share their resources
		_get_shape_res($LeftWall/Shape).size.y = new_size.y
		#_get_shape_res($RightWall/Shape).size.y = new_size.y
		_get_shape_res($UpWall/Shape).size.x = new_size.x
		#_get_shape_res($DownWall/Shape).size.x = new_size.x
		var new_half_size = new_size / 2.0
		$LeftWall.position = Vector2(-new_half_size.x, 0)
		$RightWall.position = Vector2(new_half_size.x, 0)
		$UpWall.position = Vector2(0, -new_half_size.y)
		$DownWall.position = Vector2(0, new_half_size.y)

@export var wall_thickness : float:
	get:
		return _get_shape_res($LeftWall/Shape).size.x
	set(new_thickness):
		# Horizontal and vertical lines share their resources
		_get_shape_res($LeftWall/Shape).size.x = new_thickness
		#_get_shape_res($RightWall/Shape).size.x = new_thickness
		_get_shape_res($UpWall/Shape).size.y = new_thickness
		#_get_shape_res($DownWall/Shape).size.y = new_thickness
		var new_half_thickness = new_thickness / 2.0
		$LeftWall/Shape.position = Vector2(-new_half_thickness, 0)
		$RightWall/Shape.position = Vector2(new_half_thickness, 0)
		$UpWall/Shape.position = Vector2(0, -new_half_thickness)
		$DownWall/Shape.position = Vector2(0, new_half_thickness)

func _get_shape_res(collision : CollisionShape2D) -> RectangleShape2D:
	return collision.shape as RectangleShape2D
