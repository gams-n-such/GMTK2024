extends Node

@onready var game_config : GameConfig = preload("res://default_game_config.tres")

func _ready():
	%HUD.player = %PlayerCity
	%PlayerCity.progression_config = game_config.progression_settings
	%PlayerCity.get_level().value_changed.connect(_on_player_level_changed)

func _on_player_level_changed(attribute : Attribute, new_value : float, old_value : float) -> void:
	if new_value > old_value:
		upgrade_player()

func upgrade_player() -> void:
	var city: City = %PlayerCity
	var upgrade_options : Array[CityBlock] = _generate_player_upgrade_options(3)
	var city_builder = preload("res://Cities/city_builder.tscn").instantiate()
	city_builder.setup(upgrade_options, city)
	self.add_child(city_builder)

func _generate_player_upgrade_options(num : int) -> Array[CityBlock]:
	var result : Array[CityBlock] = []
	for i in range(3):
		result.push_back(preload("res://Cities/city_block.tscn").instantiate())
	result[0].get_node("CityBlockArtPlaceholder").texture = preload("res://Cities/city_block_art_placeholder_red.png")
	result[1].get_node("CityBlockArtPlaceholder").texture = preload("res://Cities/city_block_art_placeholder_green.png")
	result[2].get_node("CityBlockArtPlaceholder").texture = preload("res://Cities/city_block_art_placeholder_blue.png")
	return result
