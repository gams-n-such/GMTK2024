# By default just rushes to the player
class_name EnemyController
extends Controller

var player : PlayerCity

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _get_move_direction() -> Vector2:
	return _input_target_2d.global_position.direction_to(player.global_position)

func _get_aim_target() -> Vector2:
	return player.global_position
