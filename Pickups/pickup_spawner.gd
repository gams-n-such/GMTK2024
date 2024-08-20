extends Node

@export var enemy_spawner : Node
@export var exp_objects : Array[PackedScene]

var time_from_start : float = 0

func _process(delta: float) -> void:
	time_from_start += delta

func _ready() -> void:
	enemy_spawner.not_movable_enemy_spawned.connect(on_not_movable_enemy_spawned)
	enemy_spawner.jihadka_spawned.connect(on_jihadka_spawned)

func on_jihadka_spawned(jihadka: Jihadka):
	jihadka.destroyed.connect(on_jihadka_destroyed)

func on_jihadka_destroyed(jihadka: Jihadka):
	for i in jihadka.drop_count :
		spawn_exp(jihadka.get_node("CityMovement").global_position)

func on_not_movable_enemy_spawned(object):
	object.destroyed.connect(on_not_movable_enemy_destroyed)

func on_not_movable_enemy_destroyed(object):
	for i in object.drop_count :
		if randf_range(0,1) < object.drop_chance:			
			spawn_exp(object.position)

func spawn_exp(point : Vector2):
	var type : int = 0
	
	if time_from_start > 300 :
		if randf_range(0,1) < 0.1:
			type = 1
			
	if time_from_start > 900 :
		if randf_range(0,1) < 0.05:
			type = 2
			
	var exp = exp_objects[type].instantiate()
	exp.position = point + Vector2(randf_range(-100, 100),randf_range(-100, 100))
	add_child(exp)
