@tool
extends Control

# TODO values are hardcoded in
var city: City = null
var outer_radius: float = 64
var inner_radius: float = sqrt(3) / 2 * outer_radius
var origin_offset_position: Vector2
var origin_offset_spot: Vector2i

func _on_rotate_left_pressed():
	var selection = EditorInterface.get_selection().get_selected_nodes()
	for node in selection:
		if node is Node2D:
			node = node as Node2D
			node.rotation -= PI / 3


func _on_rotate_right_pressed():
	var selection = EditorInterface.get_selection().get_selected_nodes()
	for node in selection:
		if node is Node2D:
			node = node as Node2D
			node.rotation += PI / 3

func reset_origin_offset():
	origin_offset_position = Vector2(0, 0)
	origin_offset_spot = Vector2i(%SpinBoxX.value / 2, %SpinBoxY.value / 2)
	origin_offset_position = spot_to_position(origin_offset_spot)

func find_city() -> City:
	if get_tree().edited_scene_root is City:
		return get_tree().edited_scene_root
	for node in get_tree().edited_scene_root.get_children():
		if node is City:
			return node as City
	return null

func _on_fix_grid_pressed():
	city = find_city()
	print(city.name)
	city.grid_size = Vector2i(%SpinBoxX.value, %SpinBoxY.value)
	reset_origin_offset()
	
	var city_blocks: Array[CityBlock]
	for node in get_tree().edited_scene_root.get_children():
		if (node as CityBlock) != null:
			city_blocks.push_back(node as CityBlock)
	for node in city.get_children():
		if node is CityBlockHolder:
			for node_in_holder in node.get_children():
				if (node_in_holder as CityBlock) != null and node_in_holder.position != Vector2(0, 0):
					city_blocks.push_back(node_in_holder)
	
	for block in city_blocks:
		var closest_spot: Vector2i = find_closest_spot(block.global_position)
		var holder: CityBlockHolder = null
		for node in city.get_children():
			if node is CityBlockHolder and (node as CityBlockHolder).spot == closest_spot:
				holder = node as CityBlockHolder
		if holder == null:
			holder = preload("res://addons/citybuilderplugin/city_block_holder.tscn").instantiate()
			holder.spot = closest_spot
			holder.name = "Holder at " + str(closest_spot)
			city.add_child(holder)
			holder.position = spot_to_position(closest_spot)
			holder.owner = get_tree().edited_scene_root
		var rot: float = block.rotation
		block.reparent(holder, false)
		block.global_position = holder.global_position
		block.rotation = rot
		
	

func spot_to_position(spot: Vector2i) -> Vector2:
	return Vector2(	spot.y * outer_radius * 1.5, 
					(spot.x + spot.y * 0.5 - spot.y / 2) * inner_radius * 2) - origin_offset_position

func is_spot_in_bounds(spot: Vector2i) -> bool:
	return 0 <= spot.x and spot.x < %SpinBoxX.value and 0 <= spot.y and spot.y < %SpinBoxY.value

func find_closest_spot(pos: Vector2) -> Vector2i:
	var closest: Vector2i = Vector2i(0, 0)
	for row in range(%SpinBoxY.value):
		for col in range(%SpinBoxX.value):
			if (spot_to_position(Vector2i(col, row)) - pos).length() < (spot_to_position(closest) - pos).length():
				closest = Vector2i(col, row)
	
	return closest
