extends TowerDefenceWeaponUnit

var target_position: Vector2 = Vector2.ZERO:
	set(value):
		target_position = value
		%Laser2DShot.rotation = value.angle()
		%Laser2DBeam.rotation = value.angle()

var _laser_cooldown: CooldownTimer = CooldownTimer.new()
var laser_cooldown_delta: float = 1.0

func _init() -> void:
	super._init(
		&"laser", 
		Core.WeaponType.PROJECTILE,
		[
			WeaponAttack.new(&"laser_shot", 2),
			WeaponAttack.new(&"laser_beam", 2),
		]
	)

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		_laser_cooldown.reset()
		
		%Area2DAttack.position = Vector2.ZERO
		%CollisionShape2D.shape.size = Vector2.ZERO
		
		if reset_type_ == Core.ResetType.RESTART:
			%Laser2DShot.stop()
			%Laser2DBeam.stop()
	elif reset_type_ == Core.ResetType.STOP:
		%Laser2DShot.stop()
		%Laser2DBeam.stop()
			
func _ready() -> void:
	attack_after.connect(_on_attack_after)
	
	_laser_cooldown = CooldownTimer.new(laser_cooldown_delta)
	
func _update_weapon() -> void:
	#TODO: Modifiers
	pass
	
func _on_attack_after(_weapon: WeaponUnit, attack_: AttackValue) -> void:
	if attack_.meta.weapon_attack_alias == &"laser_shot":
		%Laser2DShot.start()
		_laser_cooldown.start()
	elif attack_.meta.weapon_attack_alias == &"laser_beam":
		%Laser2DBeam.start()
		_laser_cooldown.start()
			
func _process(delta_: float) -> void:
	super._process(delta_)

	if not is_running():
		return
		
	if _laser_cooldown.is_stopped:
		return
	
	
	if %Laser2DShot.is_on:
		var points: PackedVector2Array = %Laser2DShot.get_points()
		
		%CollisionShape2D.shape.size = Vector2(
			points[1].x - points[0].x,
			%Laser2DShot.beam_width,
		)
		
		%Area2DAttack.position = Vector2(
			points[0].x + ((points[1].x - points[0].x) / 2),
			0
		)
	elif %Laser2DBeam.is_on:
		var points: PackedVector2Array = %Laser2DBeam.get_points()
		
		%CollisionShape2D.shape.size = Vector2(
			points[1].x - points[0].x,
			%Laser2DBeam.beam_width,
		)
		
		%Area2DAttack.position = Vector2(
			points[0].x + ((points[1].x - points[0].x) / 2),
			0
		)
	
	_laser_cooldown.process(delta_)

	if _laser_cooldown.is_complete:
		_laser_cooldown.stop()
		
		if %Laser2DShot.is_on:
			%Laser2DShot.stop()
		
		if %Laser2DBeam.is_on:
			%Laser2DBeam.stop()
		
		%Area2DAttack.position = Vector2.ZERO
		%CollisionShape2D.shape.size = Vector2.ZERO
