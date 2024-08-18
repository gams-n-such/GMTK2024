class_name CannonConfig
extends Resource

@export_category("Cannon")
@export_range(0.0, 360.0, 1.0, "or_greater", "degrees") var turning_speed : float = 0.0
@export_range(0.0, 360.0, 1.0, "or_greater", "suffix:px") var range : float = 500.0
@export var projectile : PackedScene
@export_range(0.0, 10.0, 1.0, "or_greater") var bullets_per_series : int = 1
@export_range(0.0, 1.0, 0.01, "or_greater", "suffix:s") var reload_between_shots : float = 0.2
@export_range(0.1, 30.0, 0.1, "or_greater", "suffix:s") var reload_between_series : float = 1.0
