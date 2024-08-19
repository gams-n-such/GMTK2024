extends City

func _ready() -> void:
	super.setup_grid(Vector2i(15, 15), $Body/Core)
	pass


func _process(delta: float) -> void:
	pass
