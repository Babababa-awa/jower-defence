extends TowerDefenceWeaponUnit

var target_position: Vector2 = Vector2.ZERO

var bullet_speed: float = 200

var _semi_automatic_cooldown: CooldownTimer = CooldownTimer.new()
var semi_automatic_cooldown_delta: float = 0.2

var _attack: AttackValue = null

signal bullet_after(_weapon: WeaponUnit, attack_: AttackValue)

func _init() -> void:
	super._init(
		&"gun", 
		Core.WeaponType.PROJECTILE,
		[
			WeaponAttack.new(&"pistol", 1.5),
			WeaponAttack.new(&"semi_automatic", 1.5),
			WeaponAttack.new(&"machine_gun", 0.2)
		]
	)
	
func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		_semi_automatic_cooldown.reset()
		
func _ready() -> void:
	attack_after.connect(_on_attack_after)
	
	_semi_automatic_cooldown = CooldownTimer.new(semi_automatic_cooldown_delta * 2)
	_semi_automatic_cooldown.add_step(&"second_bullet", semi_automatic_cooldown_delta)
	
func _update_weapon() -> void:
	#TODO: Modifiers
	pass
	
func _on_attack_after(_weapon: WeaponUnit, attack_: AttackValue) -> void:
	_attack = attack_
	
	shoot_gun()
	
	if attack_.meta.weapon_attack_alias == &"semi_automatic":
		_semi_automatic_cooldown.start()
	
func shoot_gun() -> void:
	#TODO Play sfx

	var node: ProjectileUnit = await Core.nodes.get_node("res://scenes/unit/projectile/bullet.tscn")
	node.projectile_modifier = projectile_modifier
	node.add_to_group(owner_group)
	node.global_position = global_position
	node.direction = rad_to_deg(global_position.angle_to_point(target_position)) + 90
	node.speed = bullet_speed
	
	bullet_after.emit(self, _attack)

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
