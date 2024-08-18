#class_name Projectile
extends RigidBody2D

@export var config : ProjectileConfig

var instigator : Node = null

var _explosion_circle : CircleShape2D = (%ExplosionShape.shape as CircleShape2D)

func _ready() -> void:
	_explosion_circle.radius = config.damage_radius
	linear_velocity = Vector2.RIGHT * config.speed
	%DeathTimer.start(config.projectile_lifetime)
	pass

func _physics_process(delta: float) -> void:
	move_and_collide(linear_velocity * delta)
	pass

func _on_death_timer_timeout() -> void:
	process_mode = PROCESS_MODE_DISABLED
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body is not City:
		_on_target_hit(body)

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body is not City:
		return
	var hit_city_block : Node = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
	_on_target_hit(hit_city_block)

func _on_target_hit(hit_target : Node) -> void:
	process_mode = PROCESS_MODE_DISABLED
	if config.damage_radius > 0:
		_deal_aoe_damage()
	else:
		_deal_direct_damage(hit_target)
	# TODO: VFX, SFX
	# TODO: await animation end
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _deal_aoe_damage() -> void:
	var hit_bodies : Array[Node] = %ExplosionArea.get_overlapping_bodies()
	var hit_targets : Array[Node] = []
	for body in hit_bodies:
		if body is City:
			# TODO: get all blocks
			pass
		else:
			hit_targets.append(body)
	for target in hit_targets:
		_deal_direct_damage(target)

func _deal_direct_damage(target : Node) -> void:
	target.take_damage(config.damage, instigator, self)
