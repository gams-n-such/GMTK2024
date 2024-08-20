extends Control
class_name CityBlockCard

@onready var city_block: CityBlock
signal pressed(block: CityBlock)
var preview_texture: Texture2D
var city_block_name:= "Name of the block"
var city_block_stats = {"stat1": 10}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_city_block(block: CityBlock):
	city_block = block
	#%PreviewTextureRect.texture = block.get_node("CitydBlockArtPlaceholder").texture
	for key in city_block_stats.keys():
		var value = city_block_stats[key]
		var label: Label = Label.new()
		label.text = key + ": " + str(value)
		%StatsVBox.add_child(label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	pressed.emit(city_block)
	pass # Replace with function body.
