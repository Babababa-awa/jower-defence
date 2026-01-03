extends TowerDefenceWeaponUnit

var target_position: Vector2 = Vector2.ZERO:
	set(value):
		target_position = value
		%Laser2DShot.rotation = to_local(value).angle()
		%Laser2DBeam.rotation = to_local(value).angle()

var _laser_shot_cooldown: CooldownTimer
var laser_shot_cooldown_delta: float = 1.0

var _laser_beam_cooldown: CooldownTimer
var laser_beam_cooldown_delta: float = 3.0
var laser_beam_cooldown_shoot_delta: float = 0.7

var laser_shot_delta: float = 1.75
var laser_shot_delta_fast: float = 1.25
var laser_beam_delta: float = 4.5
var laser_beam_delta_fast: float = 1.5

var _current_attack: AttackValue = null
var _current_attack_angle: float = 0.0
var _current_target_position: Vector2 = Vector2.ZERO

var _current_laser_shot_angle_index: int = 0
var _current_laser_beam_weapon_modifier: Core.WeaponModifier = Core.WeaponModifier.NONE

var _laser_shot_spread_angles: Array[float] = [0.0, 10.0, 0.0, -10.0]
var _laser_beam_spread_angle: float = 30.0

var _laser_shot_cluster_angles: Array[float] = [0.0, 5.0, 0.0, -5.0]
var _laser_beam_cluster_angle: float = 10.0

signal laser_beam_started()
signal laser_beam_stopped()

func _init() -> void:
	super._init(
		&"laser", 
		Core.WeaponType.LASER,
		[
			WeaponAttack.new(&"laser_shot", laser_shot_delta),
			WeaponAttack.new(&"laser_beam", laser_beam_delta),
		]
	)

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		if reset_type_ == Core.ResetType.START:
			_laser_shot_cooldown = CooldownTimer.new(laser_shot_cooldown_delta)
			_laser_beam_cooldown = CooldownTimer.new(laser_beam_cooldown_delta)
			_laser_beam_cooldown.add_step(&"shoot", laser_beam_cooldown_shoot_delta)
		else:
			_laser_shot_cooldown.reset()
			_laser_beam_cooldown.reset()
		
		_current_attack = null
		_current_laser_shot_angle_index = 0

		%Area2DAttackShot.position = Vector2.ZERO
		%Area2DAttackShot.monitorable = false
		%Area2DAttackShot.monitoring = false
		%CollisionShape2DShot.shape.size = Vector2.ZERO
		
		%Area2DAttackBeam.position = Vector2.ZERO
		%Area2DAttackBeam.monitorable = false
		%Area2DAttackBeam.monitoring = false
		%CollisionShape2DBeam.shape.size = Vector2.ZERO
		
		if reset_type_ == Core.ResetType.RESTART:
			%Laser2DShot.stop()
			%Laser2DBeam.stop()
	elif reset_type_ == Core.ResetType.STOP:
		%Laser2DShot.stop()
		%Laser2DBeam.stop()
			
func _ready() -> void:
	super._ready()
	
	attack_after.connect(_on_attack_after)
	
func _update_weapon_modifier() -> void:
	if weapon_modifier == Core.WeaponModifier.SPEED:
		attacks[0].delta = laser_shot_delta_fast
		attacks[1].delta = laser_beam_delta_fast
	else:
		attacks[0].delta = laser_shot_delta
		attacks[1].delta = laser_beam_delta
		
	_current_laser_shot_angle_index = 0
	
	%Laser2DShot.rotation = to_local(target_position).angle()
	%Laser2DBeam.rotation = to_local(target_position).angle()
	
func _on_attack_after(_weapon: WeaponUnit, attack_: AttackValue) -> void:
	_current_attack = attack_
	_current_target_position = to_local(target_position)
	
	_update_attack_angle(attack_.meta.weapon_attack_alias)

	if attack_.meta.weapon_attack_alias == &"laser_shot":
		%Laser2DShot.rotation_degrees = rad_to_deg(_current_target_position.angle()) + _current_attack_angle
		%Laser2DShot.start()
		%Area2DAttackShot.monitorable = true
		%Area2DAttackShot.monitoring = true
		
		_laser_shot_cooldown.start()
	elif attack_.meta.weapon_attack_alias == &"laser_beam":
		%Laser2DBeam.rotation_degrees = rad_to_deg(_current_target_position.angle()) + _current_attack_angle
		_laser_beam_cooldown.start()

func _update_attack_angle(weapon_alias: StringName) -> void:
	if weapon_alias == &"laser_shot":
		if weapon_modifier == Core.WeaponModifier.SPREAD:
			_current_attack_angle = _laser_shot_spread_angles[_current_laser_shot_angle_index]
			_current_laser_shot_angle_index = (_current_laser_shot_angle_index + 1) % _laser_shot_spread_angles.size()
		elif weapon_modifier == Core.WeaponModifier.CLUSTER:
			_current_attack_angle = _laser_shot_cluster_angles[_current_laser_shot_angle_index]
			_current_laser_shot_angle_index = (_current_laser_shot_angle_index + 1) % _laser_shot_cluster_angles.size()
		else:
			_current_attack_angle = 0.0
	elif weapon_alias == &"laser_beam":
		_current_laser_beam_weapon_modifier = weapon_modifier
			
		if weapon_modifier == Core.WeaponModifier.SPREAD:
			_current_attack_angle = -_laser_beam_spread_angle / 2
		elif weapon_modifier == Core.WeaponModifier.CLUSTER:
			_current_attack_angle = -_laser_beam_cluster_angle / 2
		else:
			_current_attack_angle = 0.0

func _process(delta_: float) -> void:
	super._process(delta_)

	if not is_running():
		return
	
	_process_laser_shot(delta_)
	_process_laser_beam(delta_)
	
func _process_laser_shot(delta_: float) -> void:
	if _laser_shot_cooldown.is_stopped:
		return
		
	_laser_shot_cooldown.process(delta_)
		
	if %Laser2DShot.is_on:
		var points: PackedVector2Array = %Laser2DShot.get_points()
		
		%CollisionShape2DShot.shape.size = Vector2(
			points[1].x - points[0].x,
			%Laser2DShot.beam_width,
		)
		
		%Area2DAttackShot.position = Vector2(
			points[0].x + ((points[1].x - points[0].x) / 2),
			0
		)
		
	if _laser_shot_cooldown.is_complete:
		_laser_shot_cooldown.stop()
		
		if %Laser2DShot.is_on:
			%Laser2DShot.stop()
		
		%Area2DAttackShot.position = Vector2.ZERO
		%Area2DAttackShot.monitorable = false
		%Area2DAttackShot.monitoring = false
		%CollisionShape2DShot.shape.size = Vector2.ZERO
		
func _process_laser_beam(delta_: float) -> void:
	if _laser_beam_cooldown.is_stopped:
		return
		
	_laser_beam_cooldown.process(delta_)
	
	if %Laser2DBeam.is_on:
		if _current_laser_beam_weapon_modifier == Core.WeaponModifier.SPREAD:
			var laser_beam_total_delta_: float = laser_beam_cooldown_delta - laser_beam_cooldown_shoot_delta
			var laser_beam_current_delta_: float = (_laser_beam_cooldown.current_delta - laser_beam_cooldown_shoot_delta)
			var angle_: float = _laser_beam_spread_angle / laser_beam_total_delta_ * laser_beam_current_delta_
			
			%Laser2DBeam.rotation_degrees = rad_to_deg(_current_target_position.angle()) + _current_attack_angle + angle_
		elif _current_laser_beam_weapon_modifier == Core.WeaponModifier.CLUSTER:
			var laser_beam_total_delta_: float = laser_beam_cooldown_delta - laser_beam_cooldown_shoot_delta
			var laser_beam_current_delta_: float = (_laser_beam_cooldown.current_delta - laser_beam_cooldown_shoot_delta)
			var angle_: float = _laser_beam_cluster_angle / laser_beam_total_delta_ * laser_beam_current_delta_
			
			%Laser2DBeam.rotation_degrees = rad_to_deg(_current_target_position.angle()) + _current_attack_angle + angle_
		
		var points: PackedVector2Array = %Laser2DBeam.get_points()
		
		%CollisionShape2DBeam.shape.size = Vector2(
			points[1].x - points[0].x,
			%Laser2DBeam.beam_width,
		)
		
		%Area2DAttackBeam.position = Vector2(
			points[0].x + ((points[1].x - points[0].x) / 2),
			0
		)
	
	if _laser_beam_cooldown.is_on_step(&"shoot"):
		laser_beam_started.emit()
		%Area2DAttackBeam.monitorable = true
		%Area2DAttackBeam.monitoring = true
		%Laser2DBeam.start()
	elif _laser_beam_cooldown.is_complete:
		_laser_beam_cooldown.stop()
		
		if %Laser2DBeam.is_on:
			laser_beam_stopped.emit()
			%Laser2DBeam.stop()
		
		%Area2DAttackBeam.position = Vector2.ZERO
		%Area2DAttackBeam.monitorable = false
		%Area2DAttackBeam.monitoring = false
		%CollisionShape2DBeam.shape.size = Vector2.ZERO
