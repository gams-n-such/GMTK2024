class_name PlayerCity
extends City

var _progression_config : ProgressionConfig = null
var progression_config : ProgressionConfig:
	get:
		return _progression_config
	set(new_config):
		_progression_config = new_config
		update_xp_to_level_up()

@onready var camera : Camera2D = $Body/Camera2D

func _ready() -> void:
	setup_grid()
	pass

func _process(delta: float) -> void:
	pass

func get_level() -> Attribute:
	return $Level

func get_experience() -> Attribute:
	return $Experience

func _on_experience_value_changed(attribute: Attribute, new_value: float, old_value : float) -> void:
	if (new_value >= old_value):
		try_level_up()

func try_level_up() -> void:
	if %Experience.value >= %Experience.max_value:
		level_up()

func level_up() -> void:
	assert(%Experience.value >= %Experience.max_value)
	%Experience.add_instant(-%Experience.max_value)
	%Level.add_instant(1)

func _on_level_value_changed(attribute: Attribute, new_value: float, old_value : float) -> void:
	update_xp_to_level_up()

func update_xp_to_level_up() -> void:
	if progression_config:
		%Experience.max_value = progression_config.exp_to_level_up[%Level.value]
