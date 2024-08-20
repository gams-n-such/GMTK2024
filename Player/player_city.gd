class_name PlayerCity
extends City

func _ready() -> void:
	setup_grid()
	pass


func _process(delta: float) -> void:
	pass


func get_level() -> Attribute:
	return $Level

func get_experience() -> Attribute:
	return $Experience
