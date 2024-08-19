class_name PlayerCity
extends City

func _ready() -> void:
	super.setup_grid(Vector2i(15, 15), $Body/Core)
	pass


func _process(delta: float) -> void:
	pass


func get_level() -> Attribute:
	return $Level

func get_experience() -> Attribute:
	return $Experience
