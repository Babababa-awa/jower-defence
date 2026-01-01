extends EnemyUnit
class_name TowerDefenceEnemyUnit

var unit_settings: UnitSettings = null
var movement_speed: float = 500
var kill_money: int = 5
var path: Path2D = null
var progress: float = 0.0

var is_slowed: bool = false
var is_stunned: bool = false
var is_poisoned: bool = false


var slow_cooldown_duration_delta: float = 2000
var slow_cooldown_delta: float = 5000
var _slow_cooldown: CooldownTimer

var stun_cooldown_duration_delta: float = 2000
var stun_cooldown_delta: float = 5000
var _stun_cooldown: CooldownTimer

var poison_cooldown_delta: float = 2000
var _poison_cooldown: CooldownTimer

func _init(alias_: StringName) -> void:
	super._init(alias_)
	
	collision.is_enabled_default = false
	field.is_enabled_default = false
	climb.is_enabled_default = false
	fall.is_enabled_default = false
	weapons.is_enabled_default = false
	move.is_enabled_default = false
	
	alignment = Core.Alignment.CENTER_CENTER
	
	life.kill_after.connect(_on_kill_after)
	life.kill_complete.connect(_on_kill_complete)
	
	damage.damage_before.connect(_on_damage_before)
	damage.damage_after.connect(_on_damage_after)
	
func _on_damage_before(reason_: StringName, damage_value_: DamageValue) -> void:
	if damage_value_.meta.has(&"damage_modifer"):
		if damage_value_.meta.damage_modifer == Core.DamageModifier.HEAVY:
			if unit_settings.damage_heavy == Core.DamageEffect.WEAK:
				damage_value_.damage *= 1.5
			elif unit_settings.damage_heavy == Core.DamageEffect.STRONG:
				damage_value_.damage /= 1.5
		elif damage_value_.meta.damage_modifer == Core.DamageModifier.PIERCING:
			if unit_settings.damage_piercing == Core.DamageEffect.WEAK:
				damage_value_.damage *= 1.5
			elif unit_settings.damage_piercing == Core.DamageEffect.STRONG:
				damage_value_.damage /= 1.5
		elif damage_value_.meta.damage_modifer == Core.DamageModifier.EXPLOSIVE:
			if unit_settings.damage_explosive == Core.DamageEffect.WEAK:
				damage_value_.damage *= 1.5
			elif unit_settings.damage_explosive == Core.DamageEffect.STRONG:
				damage_value_.damage /= 1.5

func _on_damage_after(reason_: StringName, damage_value_: DamageValue) -> void:
	if damage_value_.meta.has(&"attack_modifer"):
		if damage_value_.meta.attack_modifier == Core.AttackModifier.SLOW:
			if unit_settings.attack_slow and _slow_cooldown.start():
				is_slowed = true
		elif damage_value_.meta.attack_modifier == Core.AttackModifier.STUN:
			if unit_settings.attack_stun and _stun_cooldown.start():
				is_stunned = true
		elif damage_value_.meta.attack_modifier == Core.AttackModifier.POISON:
			if unit_settings.attack_poison and _poison_cooldown.start():
				is_poisoned = true

func _on_kill_after(reason_: StringName) -> void:
	path = null
	%Area2DDamage.monitoring = false
	%Area2DDamage.monitorable = false
	%Area2DAttack.monitoring = false
	%Area2DAttack.monitorable = false
	%CollisionShape2D.disabled = true
	
	if Core.level is TowerDefenceLevel:
		Core.level.add_money(kill_money)
	
func _on_kill_complete(reason_: StringName) -> void:
	Core.nodes.free_node(self)

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		progress = 0.0
		unit_mode = Core.UnitMode.NORMAL
		
		is_slowed = false
		is_stunned = false
		is_poisoned = false
		
		if reset_type_ == Core.ResetType.START:
			_slow_cooldown = CooldownTimer.new(slow_cooldown_delta)
			_slow_cooldown.add_step(&"duration", slow_cooldown_duration_delta)
			
			_stun_cooldown = CooldownTimer.new(slow_cooldown_delta)
			_stun_cooldown.add_step(&"duration", slow_cooldown_duration_delta)
			
			_poison_cooldown = CooldownTimer.new(poison_cooldown_delta)
		else:
			_slow_cooldown.reset()
			_stun_cooldown.reset()
			_poison_cooldown.reset()
		
		%Area2DDamage.monitoring = true
		%Area2DDamage.monitorable = true
		%Area2DAttack.monitoring = true
		%Area2DAttack.monitorable = true
		%CollisionShape2D.disabled = false
	elif reset_type_ == Core.ResetType.STOP:
		path = null

func _process(delta_: float) -> void:
	super._process(delta_)
	
	if not is_running():
		return
	
	if path == null:
		return
		
	_slow_cooldown.process(delta_)
	_stun_cooldown.process(delta_)
	_poison_cooldown.process(delta_)
	
	if _slow_cooldown.is_on_step(&"duration"):
		is_slowed = false
	elif _slow_cooldown.is_complete:
		_slow_cooldown.stop()
	
	if _slow_cooldown.is_on_step(&"duration"):
		is_stunned = false
	elif _stun_cooldown.is_complete:
		_slow_cooldown.stop()
		
	if _poison_cooldown.is_complete:
		health.damage(unit_settings.poison_damage, true)
		_poison_cooldown.start()
		
func _physics_process(delta_: float) -> void:
	super._physics_process(delta_)
		
	if not is_running():
		return
		
	if path == null:
		return
	
	if is_stunned:
		return
	
	if is_slowed:
		progress += (movement_speed / 2) * delta_
	else:
		progress += movement_speed * delta_

	progress = min(progress, path.curve.get_baked_length())
	var position_: Vector2 = path.curve.sample_baked(progress, true)
	global_position = path.to_global(position_)
	
	if progress == path.curve.get_baked_length():
		path = null
		Core.nodes.free_node(self)
	
func set_path(path_: Path2D) -> void:
	if path_ == null or path_.curve == null or path_.curve.get_baked_length() == 0:
		path = null
	else:
		path = path_
		position = path_.curve.get_baked_points()[0]
