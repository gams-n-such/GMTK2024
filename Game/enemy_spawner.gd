extends Node2D

var time1 : float = 0
var time2 : float = 0
var time3 : float = 0

var not_movable_enemy : Array[PackedScene]
var arena

var cities : Array[PackedScene]

signal not_movable_enemy_spawned(object)

func _ready() -> void:
	arena = get_tree().get_first_node_in_group("Arena")
	not_movable_enemy.append( load("res://GameObjects/destructible_object_town.tscn"))
	not_movable_enemy.append( load("res://GameObjects/destructible_object_city.tscn"))
	not_movable_enemy.append( load("res://GameObjects/destructible_object_factory.tscn"))
	
	cities.append(load("res://Enemies/1_CitySmall/enemy_city_small.tscn"))
	cities.append(load("res://Enemies/2_CityMed/enemy_city_medium.tscn"))
	cities.append(load("res://Enemies/3_CityLarge/enemy_city_large.tscn"))


func _process(delta: float) -> void:
	time1 += delta
	if time1 >= 300/ time1:
		time1 = 0
		_process1()
	
	time2 += delta
	if time2 >= 5:
		time2 = 0
		_process2()

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
	
