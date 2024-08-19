extends "res://Shooting/cannon.gd"


func _ready() -> void:
	super._ready()
	target = %CursorTarget
	%TargetUpdateTimer.process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	super._process(delta)
	%CursorTarget.global_position = get_global_mouse_position()
