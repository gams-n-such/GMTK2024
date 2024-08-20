extends Node

@export var hp_attribute : Attribute
@export var colored_node : Node2D


func _ready() -> void:
	if hp_attribute != null and colored_node != null:
		hp_attribute.value_changed.connect(_on_health_value_changed)


func _on_health_value_changed(attr : Attribute, new_value : float, old_value : float) -> void:
	colored_node.self_modulate = Color.WHITE.lerp(Color.RED, new_value / attr.max_value)
