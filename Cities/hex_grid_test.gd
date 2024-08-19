extends Node2D

@onready var hex_grid: HexGrid = get_node("HexGrid") as HexGrid
@onready var block = preload("res://Cities/city_block.tscn")
@onready var camera: Camera2D = $Camera2D
@onready var hex_sprite: CompressedTexture2D = preload("res://Cities/city_block_art_placeholder_half_alpha.png")
var available_positions: Array[Array]

# Called when the node enters the scene tree for the first time.
func _ready():
	hex_grid.setup_grid(Vector2i(50, 50), block.instantiate())
	camera.global_position = hex_grid.origin.global_position
	available_positions = hex_grid.get_available_spots()
	reset_available_positions()

func _input(event):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			var closest:= 0 
			var mouse_pos:= get_global_mouse_position()
			for i in range(available_positions.size()):
				if (mouse_pos - available_positions[i][1]).length() < (mouse_pos - available_positions[closest][1]).length():
					closest = i
			
			if available_positions.is_empty() or (available_positions[closest][1] - mouse_pos).length() > hex_grid.inner_radius:
				return
			
			var b: CityBlock = block.instantiate()
			hex_grid.add_city_block_index(closest, b)
			reset_available_positions()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			var city_blocks = hex_grid.get_children()
			city_blocks.filter(func(child): return child.is_class("CityBlock"))
			city_blocks = city_blocks as Array[CityBlock]
			var closest:= city_blocks.front() as CityBlock
			var mouse_pos:= get_global_mouse_position()
			for block in city_blocks:
				if (mouse_pos - block.global_position).length() < (mouse_pos - closest.global_position).length():
					closest = block
			
			if city_blocks.is_empty() or (mouse_pos - closest.global_position).length() > hex_grid.inner_radius:
				return
			
			hex_grid.remove_city_block(closest)
			reset_available_positions()
	elif event is InputEventKey:
		if event.pressed:
			if event.key_label == KEY_W:
				camera.translate(Vector2(0, -10.0))
			if event.key_label == KEY_S:
				camera.translate(Vector2(0, 10.0))
			if event.key_label == KEY_A:
				camera.translate(Vector2(-10.0, 0))
			if event.key_label == KEY_D:
				camera.translate(Vector2(10.0, 0))
			if event.key_label == KEY_0:
				camera.zoom *= Vector2(.5, .5)
			if event.key_label == KEY_9:
				camera.zoom *= Vector2(2, 2)

func reset_available_positions():
	for child in self.get_children().filter(func(child): return child.is_class("Sprite2D")):
		self.remove_child(child)
	
	available_positions = hex_grid.get_available_spots()
	for i in available_positions:
		var temp: Sprite2D = Sprite2D.new()
		temp.texture = hex_sprite
		self.add_child(temp)
		temp.global_position = i[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
