class_name PickupBase
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var player = body.get_parent() as PlayerCity
	assert(player)
	_apply_to_player(player)
	queue_free()

func _apply_to_player(player : PlayerCity) -> void:
	pass
