class_name City
extends Node

@export var outer_radius: float = 128 / 2
var inner_radius: float = sqrt(3) / 2 * outer_radius
var origin: CityBlock
var origin_offset: Vector2 = Vector2(0, 0)
var grid_size: Vector2i
var grid: Array[Array]
var available_spots: Array[Vector2i]
var block_to_spot:= {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#region hex_grid
func setup_grid(size: Vector2i, starting_block: CityBlock):
	for i in size.y:
		grid.push_back([])
		for j in size.x:
			grid[i].push_back(null)
	grid_size = size
	origin = starting_block
	#var middle = Vector2i(0, 0)
	var middle = Vector2i(grid_size.x / 2, grid_size.y / 2)
	origin_offset = spot_to_position(middle)
	available_spots.push_back(middle)
	add_city_block_spot(middle, starting_block)

func spot_to_position(spot: Vector2i):
	return Vector2(spot.y * outer_radius * 1.5, (spot.x + spot.y * 0.5 - spot.y / 2) * inner_radius * 2) - origin_offset

func is_spot_in_bounds(spot: Vector2i):
	return 0 <= spot.x and spot.x < grid_size.x and 0 <= spot.y and spot.y < grid_size.y

func is_spot_occupied(spot: Vector2i):
	return grid[spot.y][spot.x] != null

func is_spot_not_occupied(spot: Vector2i):
	return grid[spot.y][spot.x] == null

# heavy, use sparingly
func reset_available_spots():
	var result: Array[Vector2i]
	for row in range(grid_size.y):
		for col in range(grid_size.x):
			if grid[row][col] != null:
				result.append_array(get_neighbouring_spots(Vector2i(col, row)))
	result.filter(is_spot_not_occupied)
	result = remove_duplicates(result)
	available_spots = result

# looks ugly but works
func remove_duplicates(arr: Array[Vector2i]):
	arr.sort()
	var duplicate_indexes: Array[int]
	for i in range(arr.size()):
		if 0 < i and arr[i] == arr[i - 1]:
			duplicate_indexes.push_back(i)
	for i in range(duplicate_indexes.size()):
		arr.remove_at(duplicate_indexes[i] - i)
	return arr

func get_neighbouring_spots(spot: Vector2i):
	var result: Array[Vector2i]
	var offset: int
	if (spot.y % 2) == 1: offset = 1
	else: offset = -1
	
	result = [
				Vector2i(spot.x + 1, spot.y), 
	Vector2i(spot.x + offset, spot.y - 1), 	Vector2i(spot.x + offset, spot.y + 1),
	Vector2i(spot.x, spot.y - 1), 		Vector2i(spot.x, spot.y + 1),
				Vector2i(spot.x - 1, spot.y), 
	]
	
	result = result.filter(is_spot_in_bounds)
	return result

func add_city_block_index(index: int, block: CityBlock):
	if index < 0 or available_spots.size() <= index:
		print("index %d out of bounds", index)
		return
	add_city_block_spot(available_spots[index], block)

func add_city_block_spot(spot: Vector2i, block: CityBlock):
	var index := available_spots.find(spot)
	if index == -1: # offset is not available
		print("spot [%s] is not available", str(spot))
		return
	available_spots.remove_at(index)
	if (block.get_parent() != null): block.get_parent().remove_child(block) # reparenting given ref
	%Body.add_child(block)
	grid[spot.y][spot.x] = block
	block_to_spot.get_or_add(block, spot)
	block.position = spot_to_position(spot)
	available_spots.append_array(get_neighbouring_spots(spot).filter(is_spot_not_occupied))
	available_spots = remove_duplicates(available_spots)
	# for debugging
	#reset_available_spots()
	#print("city block added")
	#print(available_spots)

func remove_city_block(block: CityBlock):
	if block_to_spot.has(block):
		remove_city_block_at_spot(block_to_spot.get(block) as Vector2i)
	else:
		print("block is not in the grid")

func remove_city_block_at_spot(spot: Vector2i):
	var block:= grid[spot.y][spot.x] as CityBlock
	grid[spot.y][spot.x] = null
	block_to_spot.erase(block)
	self.remove_child(block)
	block.queue_free()
	block = null
	
	var not_visited = block_to_spot.duplicate()
	var to_visit: Array[Array]
	to_visit.push_back([origin, block_to_spot.get(origin)])
	
	while not to_visit.is_empty():
		block = to_visit.back()[0] as CityBlock
		spot = to_visit.back()[1] as Vector2i 
		to_visit.pop_back()
		if not_visited.has(block):
			not_visited.erase(block)
			var neighboring_spots: Array[Vector2i] = get_neighbouring_spots(spot).filter(is_spot_occupied)
			for sp in neighboring_spots:
				to_visit.push_back([grid[sp.y][sp.x], sp])
	
	for key in not_visited.keys():
		block = key
		spot = not_visited.get(key)
		grid[spot.y][spot.x] = null
		block_to_spot.erase(block)
		self.remove_child(block)
		block.queue_free()
		block = null
	
	reset_available_spots()

# returns array[[spot: Vector2i, global_position: Vector2], ...]
func get_available_spots():
	print(get_parent().rotation)
	var result: Array[Array]
	for spot in available_spots:
		result.push_back([spot, spot_to_position(spot).rotated(%Body.global_rotation) + %Body.global_position])
	return result
#endregion 
