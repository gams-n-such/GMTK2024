@tool

class_name TargetingRange
extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var _shape : CircleShape2D:
	get:
		return %Circle.shape

@export var range : float:
	get:
		return _shape.radius
	set(new_range):
		_shape.radius = new_range
