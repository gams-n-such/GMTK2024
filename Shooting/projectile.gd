#class_name Projectile
extends RigidBody2D

@export var config : ProjectileConfig

var instigator : Node = null

@onready var _collision_circle : CircleShape2D = $ProjectileCollider.shape
@onready var _explosion_circle : CircleShape2D = %ExplosionShape.shape

func _ready() -> void:
	_collision_circle.radius = config.radius
	_explosion_circle.radius = config.damage_radius
	linear_velocity = Vector2.from_angle(global_rotation) * config.speed
	%DeathTimer.start(config.projectile_lifetime)
	$HitSound.play()
	pass

var is_player : bool
func set_is_player(player : bool) -> void:
	is_player = player
	if player:
		collision_layer = CollisionStatics.player_projectile_layers
		collision_mask = CollisionStatics.player_projectile_mask
		%ExplosionArea.collision_mask = CollisionStatics.player_projectile_mask
	else:
		collision_layer = CollisionStatics.enemy_projectile_layers
		collision_mask = CollisionStatics.enemy_projectile_mask
		%ExplosionArea.collision_mask = CollisionStatics.enemy_projectile_mask

#func _draw() -> void:
	#draw_line(Vector2.ZERO, Vector2.RIGHT * config.speed, Color.HOT_PINK, 5.0)

func _physics_process(delta: float) -> void:
	#move_and_collide(Vector2.from_angle(global_rotation) * config.speed * delta)
	pass

func _on_death_timer_timeout() -> void:
	process_mode = PROCESS_MODE_DISABLED
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body is CityMovement:
		if body.get_parent() is not City:
			_on_target_hit(body.get_parent())
	elif body is not City:
		_on_target_hit(body)

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body is not CityMovement or body.get_parent() is not City:
		return
	var hit_city_block : Node = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
	_on_target_hit(hit_city_block)

func _on_target_hit(hit_target : Node) -> void:
	process_mode = PROCESS_MODE_DISABLED
	$Bullet.visible = false
	if config.damage_radius > 0:
		_deal_aoe_damage()
	else:
		_deal_direct_damage(hit_target)
	$HitSound.play()
	await $HitSound.finished
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
	if target != null and target.has_method("take_damage"):
		target.take_damage(config.damage, self, self)
