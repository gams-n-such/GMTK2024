class_name ProgressionConfig
extends Resource

@export_category("Progression")
# Index 0 is xp to get level 1 (0)
# Min level is 1
@export var exp_to_level_up : Array[int] = [
	0,
	10, 20, 30, 40, 50,
	60, 70, 80, 90
]

var max_level : int:
	get:
		return exp_to_level_up.size()

func is_valid_level(level : int) -> bool:
	return 1 <= level && level <= max_level
