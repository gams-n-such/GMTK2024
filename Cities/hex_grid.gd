extends Node2D
class_name HexGrid

var outer_radius: float = 10
var inner_radius: float = sqrt(3) / 2 * outer_radius
var origin: CityBlock
var grid_size: Vector2i
var grid: Array[Array]
var available_spots: Array[Vector2i]

func setup_grid(size: Vector2i, starting_block: CityBlock):
	for i in size.y:
		grid.push_back(Array[CityBlock])
		for j in size.x:
			grid[i].push_back(null)
	grid_size = size
	origin = starting_block
	origin.get_parent().remove_child(origin)
	self.add_child(origin)
	grid[grid_size.y / 2][grid_size.x / 2] = origin
	origin.position = Vector2i(0, 0)
	available_spots = get_neighbouring_spots(Vector2i(grid_size.x / 2, grid_size.y / 2))

func spot_to_position(spot: Vector2i):
	return Vector2((spot.x + spot.y * 0.5 - spot.y / 2) * inner_radius * 2, spot.y * outer_radius * 1.5)

func is_spot_in_bounds(spot: Vector2i):
	return !(spot.x < 0 or grid_size.x < spot.x or spot.y < 0 or grid_size.y < spot.y)

func is_spot_not_occupied(spot: Vector2i):
	return grid[spot.y][spot.x] == null

func get_neighbouring_spots(spot: Vector2i):
	var result: Array[Vector2i]
	result = [
			Vector2i(spot.x, spot.y + 1), Vector2i(spot.x + 1, spot.y + 1),
		Vector2i(spot.x - 1, spot.y), 			Vector2i(spot.x + 1, spot.y),
			Vector2i(spot.x, spot.y - 1), Vector2i(spot.x + 1, spot.y - 1)
	]
	result = result.filter(is_spot_in_bounds)
	result = result.filter(is_spot_not_occupied)
	return result

func add_city_block(block: CityBlock, spot: Vector2i):
	var index := available_spots.find(spot)
	if index == -1: # offset is not available
		return
	available_spots.remove_at(index)
	block.get_parent().remove_child(block)
	self.add_child(block)
	grid[spot.y][spot.x] = block
	block.position = spot_to_position(spot)
	available_spots.append_array(get_neighbouring_spots(spot)) 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
