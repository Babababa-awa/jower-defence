extends TowerDefenceWeaponUnit

var target_position: Vector2 = Vector2.ZERO

var _swipe_cooldown: CooldownTimer
var swipe_cooldown_delta: float = 0.75

var tail_delta: float = 1.75
var tail_delta_fast: float = 1.25
var bat_delta: float = 1.75
var bat_delta_fast: float = 1.25
var large_bat_delta: float = 1.75
var large_bat_delta_fast: float = 1.25

var _current_attack: AttackValue = null
var _current_target_position: Vector2 = Vector2.ZERO
var _current_attack_angle: float = 0.0

var _current_tail_angle_index: int = 0
var _current_bat_angle_index: int = 0
var _current_large_bat_angle_index: int = 0

var _tail_spread_angles: Array[float] = [0.0, 15.0, 0.0, -15.0]
var _bat_spread_angles: Array[float] = [0.0, 15.0, 0.0, -15.0]
var _large_bat_spread_angles: Array[float] = [0.0, 15.0, 0.0, -15.0]

var _tail_cluster_angles: Array[float] = [0.0, 5.0, 0.0, -5.0]
var _bat_cluster_angles: Array[float] = [0.0, 5.0, 0.0, -5.0]
var _large_bat_cluster_angles: Array[float] = [0.0, 5.0, 0.0, -5.0]


func _init() -> void:
	super._init(
		&"swipe", 
		Core.WeaponType.MELEE,
		[
			WeaponAttack.new(&"tail", tail_delta),
			WeaponAttack.new(&"bat", bat_delta),
			WeaponAttack.new(&"large_bat", large_bat_delta)
		]
	)

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		_swipe_cooldown.reset()
		
		_current_attack = null
		_current_target_position = Vector2.ZERO
		_current_attack_angle = 0.0
		
		_current_tail_angle_index = 0
		_current_bat_angle_index = 0
		_current_large_bat_angle_index = 0
		
		%AnimatedSprite2DTailSlash.visible = false
		%AnimatedSprite2DBatSlash.visible = false
		%AnimatedSprite2DLargeBatSlash.visible = false
		
		%Area2DAttackTailSlash.monitorable = false
		%Area2DAttackTailSlash.monitoring = false
		%Area2DAttackBatSlash.monitorable = false
		%Area2DAttackBatSlash.monitoring = false
		%Area2DAttackLargeBatSlash.monitorable = false
		%Area2DAttackLargeBatSlash.monitoring = false
		
func _ready() -> void:
	super._ready()
	
	attack_after.connect(_on_attack_after)
	
	_swipe_cooldown = CooldownTimer.new(swipe_cooldown_delta)

func _update_weapon_modifier() -> void:
	if weapon_modifier == Core.WeaponModifier.SPEED:
		attacks[0].delta = tail_delta_fast
		attacks[1].delta = bat_delta_fast
		attacks[2].delta = large_bat_delta_fast
	else:
		attacks[0].delta = tail_delta
		attacks[1].delta = bat_delta
		attacks[2].delta = large_bat_delta
		
	_current_tail_angle_index = 0
	_current_bat_angle_index = 0
	_current_large_bat_angle_index = 0

func _on_attack_after(_weapon: WeaponUnit, attack_: AttackValue) -> void:
	_current_attack = attack_
	
	_update_attack_angle(attack_.meta.weapon_attack_alias)
	
	if attack_.meta.weapon_attack_alias == &"tail":
		%AnimatedSprite2DTailSlash.rotation_degrees = rad_to_deg(global_position.angle_to_point(target_position)) + 90.0 + _current_attack_angle
		%AnimatedSprite2DTailSlash.position = Vector2.ZERO
		%AnimatedSprite2DTailSlash.scale = Vector2(0.05, 0.05)
		%AnimatedSprite2DTailSlash.visible = true
		%Area2DAttackTailSlash.monitorable = true
		%Area2DAttackTailSlash.monitoring = true
		_swipe_cooldown.start()
	elif attack_.meta.weapon_attack_alias == &"bat":
		%AnimatedSprite2DBatSlash.rotation_degrees = rad_to_deg(global_position.angle_to_point(target_position)) + 90.0 + _current_attack_angle
		%AnimatedSprite2DBatSlash.position = Vector2.ZERO
		%AnimatedSprite2DBatSlash.scale = Vector2(0.05, 0.05)
		%AnimatedSprite2DBatSlash.visible = true
		%Area2DAttackBatSlash.monitorable = true
		%Area2DAttackBatSlash.monitoring = true
		_swipe_cooldown.start()
	elif attack_.meta.weapon_attack_alias == &"large_bat":
		%AnimatedSprite2DLargeBatSlash.rotation_degrees = rad_to_deg(global_position.angle_to_point(target_position)) + 90.0 + _current_attack_angle
		%AnimatedSprite2DLargeBatSlash.position = Vector2.ZERO
		%AnimatedSprite2DLargeBatSlash.scale = Vector2(0.05, 0.05)
		%AnimatedSprite2DLargeBatSlash.visible = true
		%Area2DAttackLargeBatSlash.monitorable = true
		%Area2DAttackLargeBatSlash.monitoring = true
		_swipe_cooldown.start()

func _update_attack_angle(weapon_alias: StringName) -> void:
	if weapon_alias == &"tail":
		if weapon_modifier == Core.WeaponModifier.SPREAD:
			_current_attack_angle = _tail_spread_angles[_current_tail_angle_index]
			_current_tail_angle_index = (_current_tail_angle_index + 1) % _tail_spread_angles.size()
		elif weapon_modifier == Core.WeaponModifier.CLUSTER:
			_current_attack_angle = _tail_cluster_angles[_current_tail_angle_index]
			_current_tail_angle_index = (_current_tail_angle_index + 1) % _tail_cluster_angles.size()
		else:
			_current_attack_angle = 0.0
	elif weapon_alias == &"bat":
		if weapon_modifier == Core.WeaponModifier.SPREAD:
			_current_attack_angle = _bat_spread_angles[_current_bat_angle_index]
			_current_bat_angle_index = (_current_bat_angle_index + 1) % _bat_spread_angles.size()
		elif weapon_modifier == Core.WeaponModifier.CLUSTER:
			_current_attack_angle = _bat_cluster_angles[_current_bat_angle_index]
			_current_bat_angle_index = (_current_bat_angle_index + 1) % _bat_cluster_angles.size()
		else:
			_current_attack_angle = 0.0
	elif weapon_alias == &"large_bat":
		if weapon_modifier == Core.WeaponModifier.SPREAD:
			_current_attack_angle = _large_bat_spread_angles[_current_large_bat_angle_index]
			_current_large_bat_angle_index = (_current_large_bat_angle_index + 1) % _large_bat_spread_angles.size()
		elif weapon_modifier == Core.WeaponModifier.CLUSTER:
			_current_attack_angle = _large_bat_cluster_angles[_current_large_bat_angle_index]
			_current_large_bat_angle_index = (_current_large_bat_angle_index + 1) % _large_bat_cluster_angles.size()
		else:
			_current_attack_angle = 0.0
	else:
		_current_attack_angle = 0.0
	
	_current_target_position = to_local(target_position)
	_current_target_position = _current_target_position.normalized().rotated(deg_to_rad(_current_attack_angle))
	
func _physics_process(delta_: float) -> void:
	super._physics_process(delta_)

	if not is_running():
		return
		
	if _swipe_cooldown.is_stopped:
		return
		
	_swipe_cooldown.process(delta_)
	
	if _swipe_cooldown.is_complete:
		if _current_attack.meta.weapon_attack_alias == &"tail":
			%AnimatedSprite2DTailSlash.visible = false
			%Area2DAttackTailSlash.monitorable = false
			%Area2DAttackTailSlash.monitoring = false
		elif _current_attack.meta.weapon_attack_alias == &"bat":
			%AnimatedSprite2DBatSlash.visible = false
			%Area2DAttackBatSlash.monitorable = false
			%Area2DAttackBatSlash.monitoring = false
		elif _current_attack.meta.weapon_attack_alias == &"large_bat":
			%AnimatedSprite2DTailSlash.visible = false
			%Area2DAttackLargeBatSlash.monitorable = false
			%Area2DAttackLargeBatSlash.monitoring = false
			
		_swipe_cooldown.stop()
	else:
		var progress_: float = 1.0 - ((_swipe_cooldown.delta - _swipe_cooldown.current_delta) / _swipe_cooldown.delta)
		
		var modulate_alpha_: float = 1.0
		if _swipe_cooldown.current_delta > _swipe_cooldown.delta / 2:
			modulate_alpha_ = lerpf(1.0, 0, (progress_ - 0.5) / 0.5)

		if _current_attack.meta.weapon_attack_alias == &"tail":
			%AnimatedSprite2DTailSlash.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DTailSlash.position = Vector2.ZERO.lerp(_current_target_position * 224, progress_)
			%AnimatedSprite2DTailSlash.modulate.a = modulate_alpha_
		elif _current_attack.meta.weapon_attack_alias == &"bat":
			%AnimatedSprite2DBatSlash.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DBatSlash.position = Vector2.ZERO.lerp(_current_target_position * 224, progress_)
			%AnimatedSprite2DBatSlash.modulate.a = modulate_alpha_
		elif _current_attack.meta.weapon_attack_alias == &"large_bat":
			%AnimatedSprite2DLargeBatSlash.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DLargeBatSlash.position = Vector2.ZERO.lerp(_current_target_position * 224, progress_)
			%AnimatedSprite2DLargeBatSlash.modulate.a = modulate_alpha_
		
	
