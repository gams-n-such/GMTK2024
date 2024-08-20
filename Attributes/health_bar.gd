extends Node3D



var hp = 5.0
var max_hp = 10.0

@export var _attribute : Attribute
var attribute : Attribute:
	get:
		return _attribute
	set(value):
		if _attribute:
			_attribute.value_changed.disconnect(_on_value_changed)
		_attribute = value
		if _attribute:
			_attribute.value_changed.connect(_on_value_changed)
		update_value()

var value : float:
	get:
		return attribute.value

var max_value : float:
	get:
		return attribute.max_value

var percent : float:
	get:
		return value / max_value

func _ready() -> void:
	assert(attribute)
	update_value()

func update_value() -> void:
	var value = percent
	$hpBar/green.position.x = -(1 - value) * 0.5
	$hpBar/green.scale.x = value * 1.01
	if value <= 0:
		visible = false

func _on_value_changed(attribute: Attribute, new_value: float, old_value: float) -> void:
	update_value()
