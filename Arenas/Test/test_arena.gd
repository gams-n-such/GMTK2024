extends Node
var city_builder: CityBuilder = null

func _input(event):
	if event is InputEventKey and event.keycode == KEY_F and event.is_released() and city_builder == null:
		#var body = ($SceneRoot/PlayerCity as City).get_node("Body")
		var city: City = ($SceneRoot/PlayerCity as City)
		var city_blocks: Array[CityBlock]
		#body.paused = true
		for i in range(3):
			city_blocks.push_back(preload("res://Cities/city_block.tscn").instantiate())
		city_blocks[0].get_node("CityBlockArtPlaceholder").texture = preload("res://testing/city_block_art_placeholder_red.png")
		city_blocks[1].get_node("CityBlockArtPlaceholder").texture = preload("res://testing/city_block_art_placeholder_green.png")
		city_blocks[2].get_node("CityBlockArtPlaceholder").texture = preload("res://testing/city_block_art_placeholder_blue.png")
		city_builder = preload("res://Cities/city_builder.tscn").instantiate()
		city_builder.setup(city_blocks, city)
		self.add_child(city_builder)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
