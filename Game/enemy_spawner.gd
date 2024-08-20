extends Node2D

var time  : float = 0
var time1  : float = 0
var time2  : float = 0
var time40 : float = 0

var not_movable_enemy : Array[PackedScene]
var arena

var cities : Array[PackedScene]

signal not_movable_enemy_spawned(object)
signal jihadka_spawned(object: Jihadka)

func _ready() -> void:
	arena = get_tree().get_first_node_in_group("Arena")
	not_movable_enemy.append( load("res://GameObjects/destructible_object_town.tscn"))
	not_movable_enemy.append( load("res://GameObjects/destructible_object_city.tscn"))
	not_movable_enemy.append( load("res://GameObjects/destructible_object_factory.tscn"))
	
	cities.append(load("res://Enemies/1_CitySmall/enemy_city_small.tscn"))
	cities.append(load("res://Enemies/2_CityMed/enemy_city_medium.tscn"))
	cities.append(load("res://Enemies/3_CityLarge/enemy_city_large.tscn"))


func _process(delta: float) -> void:
	time += delta 
	time1 += delta 
	if time1 >= clampf(300/time, 3, 0.5):
		time1 = 0
		_process1()
		
	time2 += delta
	if time2 >= 5:
		time2 = 0
		_process2()
	
	time40 += delta
	if time40 >= 1:
		if randi() % 200 / 100.0 * (time40 - 40) > 95.0:
			time40 = 0
			_process40()
	

func _process40():
	for i in range(randi() % 4 + 3):
		_spawn_jihadka()


func _process1():
	_spawn_city_enemy()
	
func _spawn_city_enemy():
	print("spaw city enemy")
	var arena_size : Vector2 = arena.arena_size
	var point : Vector2 = Vector2(0,0)
	point.x = randf_range(-arena_size.x/2 , arena_size.x/2)
	point.y = randf_range(-arena_size.y/2 , arena_size.y/2)
	var type : int = randi_range(0,2)
	var enemy = cities[type].instantiate()
	enemy.position = point
	add_child(enemy)
	#not_movable_enemy_spawned.emit(enemy)

func _process2():
	_spawn_not_movable_enemy()
	
func _spawn_not_movable_enemy():
	#print("spaw not-movable enemy")
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
