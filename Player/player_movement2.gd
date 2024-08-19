extends "res://Cities/city_movement.gd"

func _physics_process(delta) -> void:
	var move_dir : Vector2 = Input.get_vector("left", "right", "up", "down")
	var rotate_tar : Vector2 = get_global_mouse_position()
	_move_to(move_dir, rotate_tar)
	super._physics_process(delta)
