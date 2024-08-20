extends Node2D

@export var config : CannonConfig

func _ready() -> void:
	%TargetingRange.range = config.targeting_range
	%Rotator.rotation_speed_degrees = config.turning_speed
	%ReloadTimer.wait_time = config.reload_between_series
	%SeriesTimer.wait_time = config.reload_between_shots
	pass # Replace with function body.

var is_player : bool
func set_is_player(player : bool) -> void:
	is_player = player
	if player:
		%TargetingRange.collision_mask = CollisionStatics.player_targeting_mask
	else:
		%TargetingRange.collision_mask = CollisionStatics.enemy_targeting_mask

func _process(delta: float) -> void:
	pass

#region Targeting

# Prevents choosing new target until previous is dead or too far
@export var keep_targets : bool = false

var target : Node2D:
	get:
		return %Rotator.target
	set(new_target):
		%Rotator.target = new_target
		autofire_enabled = new_target != null

func _is_target_valid(target_to_check : Node2D) -> bool:
	return %TargetingRange.overlaps_body(target_to_check)

func update_target() -> void:
	if keep_targets and _is_target_valid(target):
		return
	target = _find_target()

func _find_target() -> Node2D:
	var viable_targets : Array[Node2D] = %TargetingRange.get_overlapping_bodies()
	var best_target = null
	var best_distance_sq = -1.0
	for target in viable_targets:
		var dist_sq = global_position.distance_squared_to(target.global_position)
		if best_target == null or best_distance_sq > dist_sq:
			best_target = target
			best_distance_sq = dist_sq
	return best_target

func _on_targeting_range_body_entered(body: Node2D) -> void:
	update_target()

func _on_targeting_range_body_exited(body: Node2D) -> void:
	update_target()

func _on_target_update_timer_timeout() -> void:
	update_target()

#endregion Targeting

#region Shooting

var _autofire_enabled : bool = false
var autofire_enabled : bool:
	get:
		return _autofire_enabled
	set(new_enabled):
		if _autofire_enabled != new_enabled:
			_autofire_enabled = new_enabled
			if _autofire_enabled and not is_on_reload():
				shoot()

func _on_reload_timer_timeout() -> void:
	if autofire_enabled:
		shoot()

func is_on_reload() -> bool:
	return %ReloadTimer.time_left > 0.0

var _shots_left_in_series : int = 0

func shoot() -> void:
	if is_on_reload():
		return
	_shots_left_in_series = config.bullets_per_series
	_shoot_single()
	if _shots_left_in_series > 0:
		%SeriesTimer.start()

func _on_series_timer_timeout() -> void:
	_shoot_single()

func _shoot_single() -> void:
	spawn_projectile()
	_shots_left_in_series -= 1
	if _shots_left_in_series < 1:
		_on_series_ended()

func _on_series_ended() -> void:
	%SeriesTimer.stop()
	%ReloadTimer.start()

# FIXME: revisit projectile spawning
#signal shot(projectile : Projectile, muzzle_transform : Transform2D)

signal on_shoot

func spawn_projectile() -> void:
	var projectile = config.projectile.instantiate()
	# FIXME: set proper instigator (character?)
	projectile.instigator = self
	# FIXME: revisit projectile spawning
	projectile.global_position = %Muzzle.global_position
	projectile.global_rotation = %Muzzle.global_rotation
	projectile.set_is_player(is_player)
	get_tree().root.add_child(projectile)
	emit_signal("on_shoot")

#endregion Shooting
