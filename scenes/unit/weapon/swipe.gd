extends TowerDefenceWeaponUnit

var target_position: Vector2 = Vector2.ZERO

var _swipe_cooldown: CooldownTimer
var swipe_cooldown_delta: float = 1.25
var swipe_cooldown_first_start_delta: float = 0.0
var swipe_cooldown_first_end_delta: float = 0.75
var swipe_cooldown_second_start_delta: float = 0.25
var swipe_cooldown_second_end_delta: float = 1.0

var tail_delta: float = 2.35
var tail_delta_fast: float = 2.0

var bat_delta: float = 2.35
var bat_delta_fast: float = 2.00

var large_bat_delta: float = 2.35
var large_bat_delta_fast: float = 2.00

var _current_attack: AttackValue = null
var _current_target_position1: Vector2 = Vector2.ZERO
var _current_target_position2: Vector2 = Vector2.ZERO
var _current_attack_angle: float = 0.0

var _tail_spread_angle: float = 30
var _bat_spread_angle: float = 60
var _large_bat_spread_angle: float = 90

var _tail_cluster_angle: float = 15
var _bat_cluster_angle: float = 35
var _large_bat_cluster_angle: float = 75

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
		if reset_type_ == Core.ResetType.START:
			_swipe_cooldown = CooldownTimer.new(swipe_cooldown_delta)
			_swipe_cooldown.add_step(&"second", swipe_cooldown_second_start_delta)
		else:
			_swipe_cooldown.reset()
		
		_current_attack = null
		_current_target_position1 = Vector2.ZERO
		_current_target_position2 = Vector2.ZERO
		_current_attack_angle = 0.0
		
		%AnimatedSprite2DTailSlash1.visible = false
		%AnimatedSprite2DTailSlash2.visible = false
		
		%AnimatedSprite2DBatSlash1.visible = false
		%AnimatedSprite2DBatSlash2.visible = false
		
		%AnimatedSprite2DLargeBatSlash1.visible = false
		%AnimatedSprite2DLargeBatSlash2.visible = false
		
		%Area2DAttackTailSlash1.monitorable = false
		%Area2DAttackTailSlash1.monitoring = false
		%Area2DAttackTailSlash2.monitorable = false
		%Area2DAttackTailSlash2.monitoring = false
		
		%Area2DAttackBatSlash1.monitorable = false
		%Area2DAttackBatSlash1.monitoring = false
		%Area2DAttackBatSlash2.monitorable = false
		%Area2DAttackBatSlash2.monitoring = false
		
		%Area2DAttackLargeBatSlash1.monitorable = false
		%Area2DAttackLargeBatSlash1.monitoring = false
		%Area2DAttackLargeBatSlash2.monitorable = false
		%Area2DAttackLargeBatSlash2.monitoring = false
		
func _ready() -> void:
	super._ready()
	
	attack_after.connect(_on_attack_after)

func _update_weapon_modifier() -> void:
	if weapon_modifier == Core.WeaponModifier.SPEED:
		attacks[0].delta = tail_delta_fast
		attacks[1].delta = bat_delta_fast
		attacks[2].delta = large_bat_delta_fast
	else:
		attacks[0].delta = tail_delta
		attacks[1].delta = bat_delta
		attacks[2].delta = large_bat_delta

func _on_attack_after(_weapon: WeaponUnit, attack_: AttackValue) -> void:
	_current_attack = attack_
	
	_update_attack_angle(attack_.meta.weapon_attack_alias)
	
	var _show_second: bool = false
	if (weapon_modifier == Core.WeaponModifier.SPREAD or
		weapon_modifier == Core.WeaponModifier.CLUSTER
	):
		_show_second = true
	
	if attack_.meta.weapon_attack_alias == &"tail":
		%AnimatedSprite2DTailSlash1.rotation_degrees = rad_to_deg(global_position.angle_to_point(target_position)) + 90.0 - _current_attack_angle
		%AnimatedSprite2DTailSlash1.position = Vector2.ZERO
		%AnimatedSprite2DTailSlash1.scale = Vector2(0.05, 0.05)
		%AnimatedSprite2DTailSlash1.visible = true
		%Area2DAttackTailSlash1.monitorable = true
		%Area2DAttackTailSlash1.monitoring = true
		
		%AnimatedSprite2DTailSlash2.rotation_degrees = rad_to_deg(global_position.angle_to_point(target_position)) + 90.0 + _current_attack_angle
		%AnimatedSprite2DTailSlash2.position = Vector2.ZERO
		%AnimatedSprite2DTailSlash2.scale = Vector2(0.05, 0.05)
		%AnimatedSprite2DTailSlash2.visible = _show_second
		%Area2DAttackTailSlash2.monitorable = _show_second
		%Area2DAttackTailSlash2.monitoring = _show_second
		_swipe_cooldown.start()
	elif attack_.meta.weapon_attack_alias == &"bat":
		%AnimatedSprite2DBatSlash1.rotation_degrees = rad_to_deg(global_position.angle_to_point(target_position)) + 90.0 - _current_attack_angle
		%AnimatedSprite2DBatSlash1.position = Vector2.ZERO
		%AnimatedSprite2DBatSlash1.scale = Vector2(0.05, 0.05)
		%AnimatedSprite2DBatSlash1.visible = true
		%Area2DAttackBatSlash1.monitorable = true
		%Area2DAttackBatSlash1.monitoring = true
		
		%AnimatedSprite2DBatSlash2.rotation_degrees = rad_to_deg(global_position.angle_to_point(target_position)) + 90.0 + _current_attack_angle
		%AnimatedSprite2DBatSlash2.position = Vector2.ZERO
		%AnimatedSprite2DBatSlash2.scale = Vector2(0.05, 0.05)
		%AnimatedSprite2DBatSlash2.visible = _show_second
		%Area2DAttackBatSlash2.monitorable = _show_second
		%Area2DAttackBatSlash2.monitoring = _show_second
		_swipe_cooldown.start()
	elif attack_.meta.weapon_attack_alias == &"large_bat":
		%AnimatedSprite2DLargeBatSlash1.rotation_degrees = rad_to_deg(global_position.angle_to_point(target_position)) + 90.0 - _current_attack_angle
		%AnimatedSprite2DLargeBatSlash1.position = Vector2.ZERO
		%AnimatedSprite2DLargeBatSlash1.scale = Vector2(0.05, 0.05)
		%AnimatedSprite2DLargeBatSlash1.visible = true
		%Area2DAttackLargeBatSlash1.monitorable = true
		%Area2DAttackLargeBatSlash1.monitoring = true
		
		%AnimatedSprite2DLargeBatSlash2.rotation_degrees = rad_to_deg(global_position.angle_to_point(target_position)) + 90.0 + _current_attack_angle
		%AnimatedSprite2DLargeBatSlash2.position = Vector2.ZERO
		%AnimatedSprite2DLargeBatSlash2.scale = Vector2(0.05, 0.05)
		%AnimatedSprite2DLargeBatSlash2.visible = _show_second
		%Area2DAttackLargeBatSlash2.monitorable = _show_second
		%Area2DAttackLargeBatSlash2.monitoring = _show_second
		_swipe_cooldown.start()

func _update_attack_angle(weapon_alias: StringName) -> void:
	if weapon_alias == &"tail":
		if weapon_modifier == Core.WeaponModifier.SPREAD:
			_current_attack_angle = _tail_spread_angle
		elif weapon_modifier == Core.WeaponModifier.CLUSTER:
			_current_attack_angle = _tail_cluster_angle
		else:
			_current_attack_angle = 0.0
	elif weapon_alias == &"bat":
		if weapon_modifier == Core.WeaponModifier.SPREAD:
			_current_attack_angle = _bat_spread_angle
		elif weapon_modifier == Core.WeaponModifier.CLUSTER:
			_current_attack_angle = _bat_cluster_angle
		else:
			_current_attack_angle = 0.0
	elif weapon_alias == &"large_bat":
		if weapon_modifier == Core.WeaponModifier.SPREAD:
			_current_attack_angle = _large_bat_spread_angle
		elif weapon_modifier == Core.WeaponModifier.CLUSTER:
			_current_attack_angle = _large_bat_cluster_angle
		else:
			_current_attack_angle = 0.0
	else:
		_current_attack_angle = 0.0
	
	_current_target_position1 = to_local(target_position)
	_current_target_position1 = _current_target_position1.normalized().rotated(deg_to_rad(-_current_attack_angle))
	
	_current_target_position2 = to_local(target_position)
	_current_target_position2 = _current_target_position2.normalized().rotated(deg_to_rad(_current_attack_angle))
	
func _physics_process(delta_: float) -> void:
	super._physics_process(delta_)

	if not is_running():
		return
		
	if _swipe_cooldown.is_stopped:
		return
		
	_swipe_cooldown.process(delta_)
	
	if (weapon_modifier == Core.WeaponModifier.SPREAD or
		weapon_modifier == Core.WeaponModifier.CLUSTER
	):
		_process_split(delta_)
	else:
		_process_second(delta_)
		
	if _swipe_cooldown.is_complete:
		_swipe_cooldown.stop()
		
func _process_split(delta_: float) -> void:
	if _swipe_cooldown.current_delta >= swipe_cooldown_first_end_delta:
		if _current_attack.meta.weapon_attack_alias == &"tail":
			%AnimatedSprite2DTailSlash1.visible = false
			%AnimatedSprite2DTailSlash2.visible = false
			
			%Area2DAttackTailSlash1.monitorable = false
			%Area2DAttackTailSlash1.monitoring = false
			
			%Area2DAttackTailSlash2.monitorable = false
			%Area2DAttackTailSlash2.monitoring = false
		elif _current_attack.meta.weapon_attack_alias == &"bat":
			%AnimatedSprite2DBatSlash1.visible = false
			%AnimatedSprite2DBatSlash2.visible = false
			
			%Area2DAttackBatSlash1.monitorable = false
			%Area2DAttackBatSlash1.monitoring = false
			
			%Area2DAttackBatSlash2.monitorable = false
			%Area2DAttackBatSlash2.monitoring = false
		elif _current_attack.meta.weapon_attack_alias == &"large_bat":
			%AnimatedSprite2DLargeBatSlash1.visible = false
			%AnimatedSprite2DLargeBatSlash2.visible = false
			
			%Area2DAttackLargeBatSlash1.monitorable = false
			%Area2DAttackLargeBatSlash1.monitoring = false
			
			%Area2DAttackLargeBatSlash2.monitorable = false
			%Area2DAttackLargeBatSlash2.monitoring = false
		
		_swipe_cooldown.stop()
	else:
		var progress_: float = 1.0 - ((swipe_cooldown_first_end_delta - _swipe_cooldown.current_delta) / swipe_cooldown_first_end_delta)
		
		var modulate_alpha_: float = 1.0
		if _swipe_cooldown.current_delta > _swipe_cooldown.delta / 2:
			modulate_alpha_ = lerpf(1.0, 0, (progress_ - 0.75) / 0.25)

		if _current_attack.meta.weapon_attack_alias == &"tail":
			%AnimatedSprite2DTailSlash1.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DTailSlash1.position = Vector2.ZERO.lerp(_current_target_position1 * 320, progress_)
			%AnimatedSprite2DTailSlash1.modulate.a = modulate_alpha_
			
			%AnimatedSprite2DTailSlash2.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DTailSlash2.position = Vector2.ZERO.lerp(_current_target_position2 * 320, progress_)
			%AnimatedSprite2DTailSlash2.modulate.a = modulate_alpha_
		elif _current_attack.meta.weapon_attack_alias == &"bat":
			%AnimatedSprite2DBatSlash1.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DBatSlash1.position = Vector2.ZERO.lerp(_current_target_position1 * 288, progress_)
			%AnimatedSprite2DBatSlash1.modulate.a = modulate_alpha_
			
			%AnimatedSprite2DBatSlash2.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DBatSlash2.position = Vector2.ZERO.lerp(_current_target_position2 * 288, progress_)
			%AnimatedSprite2DBatSlash2.modulate.a = modulate_alpha_
		elif _current_attack.meta.weapon_attack_alias == &"large_bat":
			%AnimatedSprite2DLargeBatSlash1.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DLargeBatSlash1.position = Vector2.ZERO.lerp(_current_target_position1 * 256, progress_)
			%AnimatedSprite2DLargeBatSlash1.modulate.a = modulate_alpha_
			
			%AnimatedSprite2DLargeBatSlash2.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DLargeBatSlash2.position = Vector2.ZERO.lerp(_current_target_position2 * 256, progress_)
			%AnimatedSprite2DLargeBatSlash2.modulate.a = modulate_alpha_
			
func _process_second(delta_: float) -> void:
	if _swipe_cooldown.current_delta >= swipe_cooldown_first_end_delta:
		if _current_attack.meta.weapon_attack_alias == &"tail":
			if %AnimatedSprite2DTailSlash1.visible:
				%AnimatedSprite2DTailSlash1.visible = false
				%Area2DAttackTailSlash1.monitorable = false
				%Area2DAttackTailSlash1.monitoring = false
		elif _current_attack.meta.weapon_attack_alias == &"bat":
			if %AnimatedSprite2DBatSlash1.visible:
				%AnimatedSprite2DBatSlash1.visible = false
				%Area2DAttackBatSlash1.monitorable = false
				%Area2DAttackBatSlash1.monitoring = false
		elif _current_attack.meta.weapon_attack_alias == &"large_bat":
			if %AnimatedSprite2DLargeBatSlash1.visible:
				%AnimatedSprite2DLargeBatSlash1.visible = false
				%Area2DAttackLargeBatSlash1.monitorable = false
				%Area2DAttackLargeBatSlash1.monitoring = false
	else:
		var progress_: float = 1.0 - ((swipe_cooldown_first_end_delta - _swipe_cooldown.current_delta) / swipe_cooldown_first_end_delta)
		
		var modulate_alpha_: float = 1.0
		if _swipe_cooldown.current_delta > _swipe_cooldown.delta / 2:
			modulate_alpha_ = lerpf(1.0, 0, (progress_ - 0.75) / 0.25)

		if _current_attack.meta.weapon_attack_alias == &"tail":
			%AnimatedSprite2DTailSlash1.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DTailSlash1.position = Vector2.ZERO.lerp(_current_target_position1 * 320, progress_)
			%AnimatedSprite2DTailSlash1.modulate.a = modulate_alpha_
		elif _current_attack.meta.weapon_attack_alias == &"bat":
			%AnimatedSprite2DBatSlash1.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DBatSlash1.position = Vector2.ZERO.lerp(_current_target_position1 * 288, progress_)
			%AnimatedSprite2DBatSlash1.modulate.a = modulate_alpha_
		elif _current_attack.meta.weapon_attack_alias == &"large_bat":
			%AnimatedSprite2DLargeBatSlash1.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DLargeBatSlash1.position = Vector2.ZERO.lerp(_current_target_position1 * 256, progress_)
			%AnimatedSprite2DLargeBatSlash1.modulate.a = modulate_alpha_

	if _swipe_cooldown.current_delta >= swipe_cooldown_second_end_delta:
		if _current_attack.meta.weapon_attack_alias == &"tail":
			%AnimatedSprite2DTailSlash2.visible = false
			%Area2DAttackTailSlash2.monitorable = false
			%Area2DAttackTailSlash2.monitoring = false
		elif _current_attack.meta.weapon_attack_alias == &"bat":
			%AnimatedSprite2DBatSlash2.visible = false
			%Area2DAttackBatSlash2.monitorable = false
			%Area2DAttackBatSlash2.monitoring = false
		elif _current_attack.meta.weapon_attack_alias == &"large_bat":
			%AnimatedSprite2DLargeBatSlash2.visible = false
			%Area2DAttackLargeBatSlash2.monitorable = false
			%Area2DAttackLargeBatSlash2.monitoring = false

		_swipe_cooldown.stop()
	elif _swipe_cooldown.current_delta >= swipe_cooldown_second_start_delta:
		var swipe_total_delta_: float = swipe_cooldown_second_end_delta - swipe_cooldown_second_start_delta
		var swipe_current_delta_: float = _swipe_cooldown.current_delta - swipe_cooldown_second_start_delta
		var progress_: float = 1.0 - ((swipe_total_delta_ - swipe_current_delta_) / swipe_total_delta_)
		
		var modulate_alpha_: float = 1.0
		if _swipe_cooldown.current_delta > _swipe_cooldown.delta / 2:
			modulate_alpha_ = lerpf(1.0, 0, (progress_ - 0.75) / 0.25)

		if _current_attack.meta.weapon_attack_alias == &"tail":
			if not %AnimatedSprite2DTailSlash2.visible:
				%AnimatedSprite2DTailSlash2.visible = true
				%Area2DAttackTailSlash2.monitorable = true
				%Area2DAttackTailSlash2.monitoring = true
			%AnimatedSprite2DTailSlash2.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DTailSlash2.position = Vector2.ZERO.lerp(_current_target_position2 * 320, progress_)
			%AnimatedSprite2DTailSlash2.modulate.a = modulate_alpha_
		elif _current_attack.meta.weapon_attack_alias == &"bat":
			if not %AnimatedSprite2DBatSlash2.visible:
				%AnimatedSprite2DBatSlash2.visible = true
				%Area2DAttackBatSlash2.monitorable = true
				%Area2DAttackBatSlash2.monitoring = true
			%AnimatedSprite2DBatSlash2.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DBatSlash2.position = Vector2.ZERO.lerp(_current_target_position2 * 288, progress_)
			%AnimatedSprite2DBatSlash2.modulate.a = modulate_alpha_
		elif _current_attack.meta.weapon_attack_alias == &"large_bat":
			if not %AnimatedSprite2DLargeBatSlash2.visible:
				%AnimatedSprite2DLargeBatSlash2.visible = true
				%Area2DAttackLargeBatSlash2.monitorable = true
				%Area2DAttackLargeBatSlash2.monitoring = true
			%AnimatedSprite2DLargeBatSlash2.scale = Vector2(0.05, 0.05).lerp(Vector2(1, 1), progress_)
			%AnimatedSprite2DLargeBatSlash2.position = Vector2.ZERO.lerp(_current_target_position2 * 256, progress_)
			%AnimatedSprite2DLargeBatSlash2.modulate.a = modulate_alpha_	
