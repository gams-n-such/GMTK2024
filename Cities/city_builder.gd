extends Node2D
class_name CityBuilder

@onready var camera: Camera2D = get_viewport().get_camera_2d()
@onready var city: City
@onready var cards: Array[CityBlockCard]
@onready var selected_block: CityBlock
@onready var preview: Sprite2D
@onready var current_snap_spot
@onready var bounding_box: Vector4
var available_positions: Array[Array]

func setup(blocks: Array[CityBlock], grid: City):
	city = grid
	available_positions = city.get_available_spots()
	for spot in available_positions:
		bounding_box[0] = min(bounding_box[0], spot[1].x) # min x
		bounding_box[1] = max(bounding_box[1], spot[1].x) # max x
		bounding_box[2] = min(bounding_box[2], spot[1].y) # min y
		bounding_box[3] = max(bounding_box[3], spot[1].y) # max y
	
	for block in blocks:
		cards.push_back(preload("res://Cities/city_block_card.tscn").instantiate())
		cards.back().set_city_block(block)
		%HBoxContainer.add_child(cards.back())
		(cards.back() as CityBlockCard).pressed.connect(card_pressed)
	reset_available_positions()

func card_pressed(block: CityBlock):
	if block.get_parent() != null : block.get_parent().remove_child(block)
	selected_block = block
	preview = (block as CityBlock).get_node("CityBlockArtPlaceholder").duplicate()
	self.add_child(preview)
	var canvas = $CanvasLayer
	self.remove_child(canvas)
	canvas.queue_free()
	print(block.name)

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	get_tree().paused = true
	pass

func _input(event):
	if event is InputEventMouseMotion and preview != null:
		current_snap_spot = find_closest_available_spot()
		reset_preview_rotation()
		if current_snap_spot != null:
			preview.global_position = current_snap_spot[1]
		else:
			preview.global_position = get_global_mouse_position()
		
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released() and current_snap_spot != null:
			city.add_city_block_spot(current_snap_spot[0], selected_block)
			reset_available_positions()
			get_tree().paused = false
			self.get_parent().remove_child(self)
			self.queue_free()
			
	elif event is InputEventKey:
		if event.pressed:
			if event.key_label == KEY_MINUS:
				camera.zoom *= Vector2(.5, .5)
			if event.key_label == KEY_PLUS:
				camera.zoom *= Vector2(2, 2)
			if event.keycode == KEY_E:
				selected_block.rotate(PI / 3)
				reset_preview_rotation()
			if event.keycode == KEY_Q:
				selected_block.rotate(-PI / 3)
				reset_preview_rotation()

func find_closest_available_spot():
	var closest:= 0 
	var mouse_pos:= get_global_mouse_position()
	for i in range(available_positions.size()):
		if (mouse_pos - available_positions[i][1]).length() < (mouse_pos - available_positions[closest][1]).length():
			closest = i
	
	if available_positions.is_empty() or (available_positions[closest][1] - mouse_pos).length() > city.outer_radius:
		return null
	
	return available_positions[closest]

func reset_available_positions():
	for child in self.get_children().filter(func(child): return child.is_class("Sprite2D")):
		if child != preview:
			self.remove_child(child)
	
	available_positions = city.get_available_spots()

func reset_preview_rotation():
	if current_snap_spot != null: preview.rotation = city.get_node("Body").global_rotation + selected_block.global_rotation
	else: preview.rotation = selected_block.global_rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	camera.translate(input_direction * 10)
	camera.global_position.x = clampf(camera.global_position.x, bounding_box[0], bounding_box[1])
	camera.global_position.y = clampf(camera.global_position.y, bounding_box[2], bounding_box[3])
	pass
