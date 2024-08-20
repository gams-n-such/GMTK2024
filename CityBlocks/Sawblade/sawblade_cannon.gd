extends Node2D

@export var damage : float = 1.0

@export var config : CannonConfig

@onready var blade : Sprite2D = %Blade

func _ready() -> void:
	%TargetingRange.range = config.targeting_range
	%DamageTimer.wait_time = config.reload_between_shots
	pass # Replace with function body.

func _process(delta: float) -> void:
	blade.rotation_degrees += config.turning_speed * delta

var is_player : bool
func set_is_player(player : bool) -> void:
	is_player = player
	if player:
		%TargetingRange.collision_mask = CollisionStatics.player_projectile_mask
	else:
		%TargetingRange.collision_mask = CollisionStatics.enemy_projectile_mask


func _on_damage_timer_timeout() -> void:
	_deal_aoe_damage()

var _targets : Array = []

func _deal_aoe_damage() -> void:
	var valid_targets = []
	for target in _targets:
		if target != null:
			_deal_direct_damage(target)
			valid_targets.append(target)
	_targets = valid_targets

func _deal_direct_damage(target : Node) -> void:
	if target.has_method("take_damage"):
		target.take_damage(damage, self, self)

func _add_target(target):
	if _targets.find(target) < 0:
		_targets.append(target)

func _remove_target(target):
	var target_idx = _targets.find(target)
	if  target_idx > 0:
		_targets.remove_at(target_idx)

func _on_targeting_range_body_entered(body: Node2D) -> void:
	if body is not City:
		_add_target(body)

func _on_targeting_range_body_exited(body: Node2D) -> void:
	if body is not City:
		_remove_target(body)

func _on_targeting_range_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is not City:
		return
	var hit_city_block : Node = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
	_add_target(hit_city_block)


func _on_targeting_range_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is not City:
		return
	var hit_city_block : Node = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
	_remove_target(hit_city_block)
