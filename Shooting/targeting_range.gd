@tool

class_name TargetingRange
extends Area2D

func _ready() -> void:
	_update_shape()

var _shape : CircleShape2D:
	get:
		return %Circle.shape

var _range : float = 200.0
@export var range : float:
	get:
		return _range
	set(new_range):
		_range = new_range
		if is_node_ready():
			_update_shape()

func _update_shape() -> void:
	_shape.radius = range
