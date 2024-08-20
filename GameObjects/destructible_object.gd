extends StaticBody2D

signal destroyed (object)

@export var drop_chance : float = 0.91
@export var drop_count : int = 5

func take_damage(damage : float, instigator : Node, causer : Node) -> void:
	%Health.add_instant(-damage)

func _on_health_value_changed(attribute : Attribute, new_value : float, old_value : float) -> void:
	if new_value <= 0.0:
		destroy()

func destroy() -> void:
	if process_mode == PROCESS_MODE_DISABLED:
		# Do once
		return
	process_mode = PROCESS_MODE_DISABLED
	# TODO: animation
	# TODO: VFX
	# TODO: SFX
	# TODO: drop loot
	destroyed.emit(self)
	# TODO: await animation end
	await get_tree().create_timer(1.0).timeout
	queue_free()
