extends Node2D

func _ready() -> void:
	$RespawnTimer.wait_time = _respawn_delay
	spawn()

@export var scene_to_spawn : PackedScene
var _spawned_node : Node2D = null

var _respawn_delay : float = 2.0
@export var respawn_delay : float:
	get:
		return _respawn_delay
	set(new_delay):
		_respawn_delay = new_delay
		if is_node_ready():
			$RespawnTimer.wait_time = _respawn_delay

func spawn() -> void:
	if _spawned_node:
		return
	_spawned_node = scene_to_spawn.instantiate()
	_spawned_node.tree_exited.connect(_on_spawned_object_destroyed)
	_spawned_node.global_position = global_position
	_spawned_node.global_rotation = global_rotation
	get_tree().root.add_child(_spawned_node)

func _on_spawned_object_destroyed() -> void:
	_spawned_node = null
	$RespawnTimer.start()

func _on_respawn_timer_timeout() -> void:
	spawn()
