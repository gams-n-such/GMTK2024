class_name City
extends Node2D

signal destroyed(city : City)

@export var core_block : CityBlock

@export var outer_radius: float = 128 / 2
var inner_radius: float = sqrt(3) / 2 * outer_radius
var origin_offset: Vector2 = Vector2(0, 0)
@export var grid_size: Vector2i = Vector2i(16, 16)
var grid: Array[Array]
var available_spots: Array[Vector2i]
var block_to_spot:= {}

@export var drop_count = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_grid()
	core_block.destroyed.connect(_on_core_block_destroyed)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_input_target() -> Node:
	return $Body

func _on_core_block_destroyed(core_block : CityBlock) -> void:
	destroy()

var _destroying : bool = false

func destroy() -> void:
	if _destroying:
		return
	_destroying = true
	destroyed.emit(self)
	# TODO: VFX/SFX/animation
	# Do not call queue_free()

func _on_block_destroyed(block : CityBlock) -> void:
	remove_city_block(block)

#region BlockManagement

@export var is_player : bool = false

func _register_block(block : CityBlock) -> void:
	block.set_is_player(is_player)
	block.destroyed.connect(_on_block_destroyed)

func _unregister_block(block : CityBlock) -> void:
	block.destroyed.disconnect(_on_block_destroyed)

func _destroy_block(block : CityBlock) -> void:
	block.destroy()

#endregion BlockManagement

#region hex_grid

func setup_grid():
	for i in grid_size.y:
		grid.push_back([])
		for j in grid_size.x:
			grid[i].push_back(null)
			available_spots.push_back(Vector2i(j, i))
	#origin = starting_blocklll
	#var middle = Vector2i(0, 0)
	var middle = Vector2i(grid_size.x / 2, grid_size.y / 2)
	origin_offset = spot_to_position(middle)
	#available_spots.push_back(middle)
	#add_city_block_spot(middle, starting_block)
	for node in self.get_children():
		if node is CityBlockHolder:
			var holder = node as CityBlockHolder
			var spot: Vector2i = holder.spot
			var block: CityBlock = null
			for temp in holder.get_children():
				if temp is CityBlock:
					block = temp as CityBlock
					break
			if block != null: add_city_block_spot(spot, block)
			holder.queue_free()
	remove_unconnected_blocks()

func spot_to_position(spot: Vector2i) -> Vector2:
	return Vector2(spot.y * outer_radius * 1.5, (spot.x + spot.y * 0.5 - spot.y / 2) * inner_radius * 2) - origin_offset

func is_spot_in_bounds(spot: Vector2i) -> bool:
	return 0 <= spot.x and spot.x < grid_size.x and 0 <= spot.y and spot.y < grid_size.y

func is_spot_occupied(spot: Vector2i) -> bool:
	return grid[spot.y][spot.x] != null

func is_spot_not_occupied(spot: Vector2i) -> bool:
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

func get_neighbouring_spots(spot: Vector2i) -> Array[Vector2i]:
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
	if (block.get_parent() != null):
		block.get_parent().remove_child(block) # reparenting given ref
	$Body.add_child(block)
	_add_block_internal(spot, block)
	available_spots.append_array(get_neighbouring_spots(spot).filter(is_spot_not_occupied))
	available_spots = remove_duplicates(available_spots)
	# for debugging
	#reset_available_spots()
	#print("city block added")
	#print(available_spots)

func _add_block_internal(spot: Vector2i, block: CityBlock):
	grid[spot.y][spot.x] = block
	block_to_spot.get_or_add(block, spot)
	block.position = spot_to_position(spot)
	_register_block(block)

func remove_city_block(block: CityBlock):
	if block_to_spot.has(block):
		remove_city_block_at_spot(block_to_spot.get(block) as Vector2i)
	else:
		print("block is not in the grid")

func remove_city_block_at_spot(spot: Vector2i):
	_remove_block_internal(spot)
	remove_unconnected_blocks()

func _remove_block_internal(spot: Vector2i):
	var block = grid[spot.y][spot.x] as CityBlock
	grid[spot.y][spot.x] = null
	block_to_spot.erase(block)
	_unregister_block(block)

func _find_unconnected_blocks() -> Dictionary:
	var not_visited = block_to_spot.duplicate()
	var to_visit: Array[Array]
	var middle: Vector2i = Vector2i(grid_size.x / 2, grid_size.y / 2)
	var block: CityBlock
	var spot: Vector2i
	to_visit.push_back([grid[middle.x][middle.y], middle])
	
	while not to_visit.is_empty():
		block = to_visit.back()[0] as CityBlock
		spot = to_visit.back()[1] as Vector2i 
		to_visit.pop_back()
		if not_visited.has(block):
			not_visited.erase(block)
			var neighboring_spots: Array[Vector2i] = get_neighbouring_spots(spot).filter(is_spot_occupied)
			for sp in neighboring_spots:
				to_visit.push_back([grid[sp.y][sp.x], sp])
	
	return not_visited

func remove_unconnected_blocks():
	var unconnected = _find_unconnected_blocks()
	for block in unconnected.keys():
		var spot = unconnected.get(block)
		_remove_block_internal(spot)
		_destroy_block(block)
	reset_available_spots()

func destroy_unconnected_blocks():
	var unconnected = _find_unconnected_blocks()
	for block in unconnected.keys():
		var spot = unconnected.get(block)
		_remove_block_internal(spot)
		_destroy_block(block)
	reset_available_spots()

# returns array[[spot: Vector2i, global_position: Vector2], ...]
func get_available_spots() -> Array[Array]:
	#print(get_parent().rotation)
	var result: Array[Array]
	for spot in available_spots:
		result.push_back([spot, spot_to_position(spot).rotated($Body.global_rotation) + $Body.global_position])
	return result
#endregion 
