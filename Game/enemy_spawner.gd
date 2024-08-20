extends Node2D

var time40: float = 0
var time30 : float = 0
var time1 : float = 0

var not_movable_enemy : Array[PackedScene]
var arena

signal not_movable_enemy_spawned(object)
signal jihadka_spawned(object: Jihadka)

func _ready() -> void:
	arena = get_tree().get_first_node_in_group("Arena")
	not_movable_enemy.append( load("res://GameObjects/destructible_object_town.tscn"))
	not_movable_enemy.append( load("res://GameObjects/destructible_object_city.tscn"))
	not_movable_enemy.append( load("res://GameObjects/destructible_object_factory.tscn"))


func _process(delta: float) -> void:
	time30 += delta
	if time30 >= 1:
		time30 = 0
		_process30()
	
	time1 += delta
	if time1 >= 1:
		time1 = 0
		_process40()
		#_process1()
	
	time40 += delta
	if time40 >= 1:
		if randi() % 200 / 100.0 * (time40 - 40) > 95.0:
			time40 = 0
			_process40()
	

func _process40():
	for i in range(randi() % 4 + 3):
		_spawn_jihadka()

func _process30():
	#print("spaw not-city enemy")
	_spawn_not_movable_enemy()
	
func _process1():
	print("spawned city enemy")
	
func _spawn_not_movable_enemy():
	print("spawned not-movable enemy")
	var arena_size : Vector2 = arena.arena_size
	var point : Vector2 = Vector2(0,0)
	point.x = randf_range(-arena_size.x/2 , arena_size.x/2)
	point.y = randf_range(-arena_size.y/2 , arena_size.y/2)
	var type : int = randi_range(0,2)
	var enemy = not_movable_enemy[type].instantiate()
	enemy.position = point
	add_child(enemy)
	not_movable_enemy_spawned.emit(enemy)
	

func _spawn_jihadka():
	print("spawned jihadka")
	var arena_size : Vector2 = arena.arena_size
	var possible_positions: Array[Vector2] = [	Vector2(arena_size.x/2 , arena_size.y/2),
												Vector2(-arena_size.x/2 , -arena_size.y/2),
												Vector2(-arena_size.x/2 , arena_size.y/2),
												Vector2(arena_size.x/2 , -arena_size.y/2)
	]
	var pos: Vector2 = possible_positions[randi_range(0, 3)]
	if randi() % 2 == 1:
		pos.y = randf_range(-arena_size.y/2 , arena_size.y/2)
	else:
		pos.x = randf_range(-arena_size.y/2 , arena_size.y/2)
	var enemy = preload("res://Enemies/Enemy_car/Jihadka.tscn").instantiate()
	enemy.position = pos
	add_child(enemy)
	jihadka_spawned.emit(enemy)
