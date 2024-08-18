class_name RotateTo2D
extends Node2D

var target : Node2D = null
@export_category("Targeting")
# Speed of 0.0 results in instant rotation
@export_range(0.0, 360.0, 1.0, "or_greater", "degrees") var rotation_speed_degrees : float = 10.0

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	tick_rotation(delta)


func tick_rotation(delta: float) -> void:
	if target != null:
		var cur_forward : Vector2 = Vector2.from_angle(global_rotation)
		var target_direction : Vector2 = global_position.direction_to(target.global_position)
		var delta_rotation_deg : float = cur_forward.angle_to(target_direction)
		var max_rotation_deg : float = rotation_speed_degrees * delta
		clampf(delta_rotation_deg, -max_rotation_deg, max_rotation_deg)
		global_rotation_degrees += delta_rotation_deg
