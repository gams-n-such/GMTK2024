extends Node2D

var time30 : float = 0
var time1 : float = 0

var not_movable_enemy : Array[PackedScene]
var arena

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
		#_process1()


func _process30():
	#print("spaw not-city enemy")
	_spawn_not_movable_enemy()
	
func _process1():
	print("spaw city enemy")
	
func _spawn_not_movable_enemy():
	print("spaw not-movable enemy")
	var arena_size : Vector2 = arena.arena_size
	var point : Vector2 = Vector2(0,0)
	point.x = randf_range(-arena_size.x/2 , arena_size.x/2)
	point.y = randf_range(-arena_size.y/2 , arena_size.y/2)
	var type : int = randi_range(0,2)
	var enemy = not_movable_enemy[type].instantiate()
	enemy.position = point
	add_child(enemy)
	
