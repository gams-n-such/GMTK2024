class_name PlayerController
extends Controller

func _get_move_direction() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

func _get_aim_target() -> Vector2:
	return _input_target_2d.get_global_mouse_position()
