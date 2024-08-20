class_name CityBlock
extends Node2D

signal destroyed(city_block : CityBlock)

@export var cannon : Node

var is_player : bool
func set_is_player(player : bool) -> void:
	is_player = player
	if is_player:
		$Outline.self_modulate = Color.AQUA
	else:
		$Outline.self_modulate = Color.ORANGE_RED
	if cannon:
		cannon.set_is_player(player)

func take_damage(damage : float, instigator : Node, causer : Node) -> void:
	%Health.add_instant(-damage)

func _on_health_value_changed(attribute: Attribute, new_value: float, old_value: float) -> void:
	if new_value <= 0:
		destroy()

var _destroiyng : bool = false

func destroy() -> void:
	if _destroiyng:
		return
	_destroiyng = true
	destroyed.emit(self)
	# TODO: VFX/SFX/animation
	queue_free()
