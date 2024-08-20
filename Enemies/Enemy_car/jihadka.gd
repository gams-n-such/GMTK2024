extends Node2D
class_name Jihadka

var player: PlayerCity
var movement: CityMovement

signal destroyed

func get_input_target() -> CharacterBody2D:
	return $CityMovement
func destroy():
	if process_mode == PROCESS_MODE_DISABLED:
		# Do once
		return
	process_mode = PROCESS_MODE_DISABLED
	# TODO: animation
	# TODO: VFX
	# TODO: SFX
	# TODO: drop loot
	destroyed.emit()
	# TODO: await animation end
	await get_tree().create_timer(1.0).timeout
	queue_free()

func take_damage(damage : float, instigator : Node, causer : Node) -> void:
	$Health.add_instant(-damage)

func _on_health_value_changed(attribute, new_value, old_value):
	if new_value <= 0.0:
		destroy()
