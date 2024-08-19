extends PickupBase

@export var experience_amount : int = 1

func _apply_to_player(player : PlayerCity) -> void:
	player.get_experience().add_instant(experience_amount)
