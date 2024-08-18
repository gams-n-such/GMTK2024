class_name Projectile
extends RigidBody2D

@export var config : ProjectileConfig

func _ready() -> void:
	linear_velocity = Vector2.RIGHT * config.speed
	%DeathTimer.start(config.projectile_lifetime)
	pass

func _physics_process(delta: float) -> void:
	move_and_collide(linear_velocity * delta)
	pass
