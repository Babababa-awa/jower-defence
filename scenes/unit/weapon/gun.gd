extends TowerDefenceWeaponUnit

var target_position: Vector2 = Vector2.ZERO

var pistol_delta: float = 1.45
var pistol_delta_fast: float = 0.95
var semi_automatic_delta: float = 1.75
var semi_automatic_delta_fast: float = 1.25
var machine_gun_delta: float = 0.2
var machine_gun_delta_fast: float = 0.125

var _semi_automatic_cooldown: CooldownTimer = CooldownTimer.new()
var semi_automatic_cooldown_delta: float = 0.2

var _current_attack: AttackValue = null
var _current_attack_angle: float = 0.0

var _current_pistol_angle_index: int = 0
var _current_semi_automatic_angle_index: int = 0
var _current_machine_gun_angle_index: int = 0

var _pistol_spread_angles: Array[float] = [0.0, 15.0, 0.0, -15.0]
var _semi_automatic_spread_angles: Array[float] = [0.0, 15.0, 0.0, -15.0]
var _machine_gun_spread_angles: Array[float] = [0.0, 5.0, 10.0, 15.0, 10.0, 5.0, 0.0, -5.0, -10.0, -15.0, -10.0, -5.0]

var _pistol_cluster_angles: Array[float] = [0.0, 5.0, 0.0, -5.0]
var _semi_automatic_cluster_angles: Array[float] = [0.0, 5.0, 0.0, -5.0]
var _machine_gun_cluster_angles: Array[float] = [0.0, 5.0, 0.0, -5.0]

signal bullet_after(_weapon: WeaponUnit, attack_: AttackValue)

func _init() -> void:
	super._init(
		&"gun", 
		Core.WeaponType.PROJECTILE,
		[
			WeaponAttack.new(&"pistol", pistol_delta),
			WeaponAttack.new(&"semi_automatic", semi_automatic_delta),
			WeaponAttack.new(&"machine_gun", machine_gun_delta)
		]
	)
	
func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		_semi_automatic_cooldown.reset()
		
		_current_attack = null
		_current_attack_angle = 0.0
		
		_current_pistol_angle_index = 0
		_current_semi_automatic_angle_index = 0
		_current_machine_gun_angle_index = 0
		
func _ready() -> void:
	super._ready()
	
	attack_after.connect(_on_attack_after)
	
	_semi_automatic_cooldown = CooldownTimer.new(semi_automatic_cooldown_delta * 2)
	_semi_automatic_cooldown.add_step(&"second_bullet", semi_automatic_cooldown_delta)
	
func _update_weapon_modifier() -> void:
	if weapon_modifier == Core.WeaponModifier.SPEED:
		attacks[0].delta = pistol_delta_fast
		attacks[1].delta = semi_automatic_delta_fast
		attacks[2].delta = machine_gun_delta_fast
	else:
		attacks[0].delta = pistol_delta
		attacks[1].delta = semi_automatic_delta
		attacks[2].delta = machine_gun_delta
		
	_current_pistol_angle_index = 0
	_current_semi_automatic_angle_index = 0
	_current_machine_gun_angle_index = 0
		
func _on_attack_after(_weapon: WeaponUnit, attack_: AttackValue) -> void:
	_current_attack = attack_
	
	_update_attack_angle(attack_.meta.weapon_attack_alias)
	
	shoot_gun()
	
	if attack_.meta.weapon_attack_alias == &"semi_automatic":
		_semi_automatic_cooldown.start()

func _update_attack_angle(weapon_alias: StringName) -> void:
	if weapon_alias == &"pistol":
		if weapon_modifier == Core.WeaponModifier.SPREAD:
			_current_attack_angle = _pistol_spread_angles[_current_pistol_angle_index]
			_current_pistol_angle_index = (_current_pistol_angle_index + 1) % _pistol_spread_angles.size()
		elif weapon_modifier == Core.WeaponModifier.CLUSTER:
			_current_attack_angle = _pistol_cluster_angles[_current_pistol_angle_index]
			_current_pistol_angle_index = (_current_pistol_angle_index + 1) % _pistol_cluster_angles.size()
		else:
			_current_attack_angle = 0.0
	elif weapon_alias == &"semi_automatic":
		if weapon_modifier == Core.WeaponModifier.SPREAD:
			_current_attack_angle = _semi_automatic_spread_angles[_current_semi_automatic_angle_index]
			_current_semi_automatic_angle_index = (_current_semi_automatic_angle_index + 1) % _semi_automatic_spread_angles.size()
		elif weapon_modifier == Core.WeaponModifier.CLUSTER:
			_current_attack_angle = _semi_automatic_cluster_angles[_current_semi_automatic_angle_index]
			_current_semi_automatic_angle_index = (_current_semi_automatic_angle_index + 1) % _semi_automatic_cluster_angles.size()
		else:
			_current_attack_angle = 0.0
	elif weapon_alias == &"machine_gun":
		if weapon_modifier == Core.WeaponModifier.SPREAD:
			_current_attack_angle = _machine_gun_spread_angles[_current_machine_gun_angle_index]
			_current_machine_gun_angle_index = (_current_machine_gun_angle_index + 1) % _machine_gun_spread_angles.size()
		elif weapon_modifier == Core.WeaponModifier.CLUSTER:
			_current_attack_angle = _machine_gun_cluster_angles[_current_machine_gun_angle_index]
			_current_machine_gun_angle_index = (_current_machine_gun_angle_index + 1) % _machine_gun_cluster_angles.size()
		else:
			_current_attack_angle = 0.0
	else:
		_current_attack_angle = 0.0

func shoot_gun() -> void:
	#TODO Play sfx
	
	var node: TowerDefenceProjectileUnit = await Core.nodes.get_node("res://scenes/unit/projectile/bullet.tscn")
	node.add_to_group(owner_group)
	node.global_position = global_position
	node.direction = rad_to_deg(global_position.angle_to_point(target_position)) + 90 + _current_attack_angle
	node.attack_modifier = attack_modifier
	node.damage_modifier = damage_modifier
	
	var vfx = VFX.play("muzzle_flash", self)
	vfx.flip_h = (fmod(node.direction, 360) > 180 or fmod(node.direction, 360) < 0)
	vfx.z_index = z_index + 1
	
	if _current_attack.meta.weapon_attack_alias == &"pistol":
		if vfx.is_flipped_h():
			vfx.offset = Vector2(-8, -8)
		else:
			vfx.offset = Vector2(8, -8)
	elif _current_attack.meta.weapon_attack_alias == &"semi_automatic":
		if vfx.is_flipped_h():
			vfx.offset = Vector2(-16, -8)
		else:
			vfx.offset = Vector2(16, -8)
	elif _current_attack.meta.weapon_attack_alias == &"machine_gun":
		if vfx.is_flipped_h():
			vfx.offset = Vector2(-16, 2)
		else:
			vfx.offset = Vector2(16, 2)
			
	bullet_after.emit(self, _current_attack)

func _process(delta_: float) -> void:
	super._process(delta_)

	if not is_running():
		return
		
	if _semi_automatic_cooldown.is_stopped:
		return

	_semi_automatic_cooldown.process(delta_)

	if _semi_automatic_cooldown.is_on_step(&"second_bullet"):
		shoot_gun()
	elif _semi_automatic_cooldown.is_complete:
		_semi_automatic_cooldown.stop()
		shoot_gun()
