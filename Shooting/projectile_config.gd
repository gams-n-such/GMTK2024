class_name ProjectileConfig
extends Resource


@export_category("Projectile")
@export_range(1, 1000.0, 1.0, "or_greater", "suffix:px/s") var speed : float = 0.0
@export_range(0.0, 100.0, 1.0, "or_greater", "suffix:HP") var damage : float = 10.0
@export_range(0.0, 100.0, 0.01, "or_greater", "suffix:px") var damage_radius : float = 0.0
@export_range(1.0, 100.0, 0.01, "or_greater", "suffix:px") var radius : float = 10.0
@export_range(1.0, 1000.0, 0.01, "or_greater", "suffix:px") var max_range : float = 200.0

var projectile_lifetime : float:
	get:
		return max_range / speed
