class_name CityMovement
extends CharacterBody2D

@export var acceleration : float = 350
@export var max_speed : float = 250
@export var rotation_speed_degrees : float = 50
@export var drag : float = 150 

var move_direction : Vector2 = Vector2(0, 0)
var rotate_target : Vector2 = Vector2(0, 0)

func _physics_process(delta) -> void:
	if move_direction != null:
		velocity += move_direction * acceleration * delta
		var velocity_length : float = velocity.length()
		if !is_nan((velocity / velocity_length).x) :
			velocity = velocity - velocity / velocity_length * drag * delta
		if velocity_length > max_speed:
			velocity = velocity / velocity_length * max_speed
	
	if rotate_target != null:
		var cur_forward : Vector2 = Vector2.from_angle(global_rotation)
		var target_direction : Vector2 = global_position.direction_to(rotate_target)
		var delta_rotation_deg : float = rad_to_deg(cur_forward.angle_to(target_direction))
		var max_rotation_deg : float = rotation_speed_degrees * delta
		delta_rotation_deg = clampf(delta_rotation_deg, -max_rotation_deg, max_rotation_deg)
		global_rotation_degrees += delta_rotation_deg
	
	move_and_slide()

func move_to(move_dir, rotate_tar):
	move_direction = move_dir
	rotate_target = rotate_tar
