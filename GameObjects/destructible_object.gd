extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

signal destroyed

func take_damage(damage : float, instigator : Node, causer : Node) -> void:
	%Health.add_instant(-damage)

func _on_health_value_changed(attribute: Attribute, new_value: float) -> void:
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
	destroyed.emit()
	# TODO: await animation end
	await get_tree().create_timer(1.0).timeout
	queue_free()
