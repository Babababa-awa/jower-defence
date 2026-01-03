extends TowerDefenceWeaponUnit

var target_points: PackedVector2Array = []:
	set(value):
		target_points = value
		_update_path()

var path_smoothness: float = 45.0
var movement_speed: float = 200.0
var movement_speed_fast: float = 250.0
var rotate_speed: float = 90.0
var rotate_speed_fast: float = 120.0
var progress: float = 0.0
var _jorb_active: bool = false
var show_speed: float = 4.0
var hide_speed: float = 4.0

var is_on_solid: bool = false
var _current_weapon_modifier = Core.WeaponModifier.NONE

func _init() -> void:
	super._init(
		&"jorb",
		Core.WeaponType.PROJECTILE,
		[
			WeaponAttack.new(&"jorb", 0),
		]
	)

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)

	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		is_on_solid = false
		%Jorb.visible = false
		stop_lasers()
		target_points.clear()
		
	elif reset_type_ == Core.ResetType.STOP:
		stop_lasers()
		%Jorb.visible = false

func _ready() -> void:
	super._ready()

	attack_after.connect(_on_attack_after)

func _on_attack_after(_weapon: WeaponUnit, attack_: AttackValue) -> void:
	_current_weapon_modifier = weapon_modifier
	
	if _current_weapon_modifier == Core.WeaponModifier.SPREAD:
		%Laser2D1.max_length = 160
		%Laser2D2.max_length = 160
		%Laser2D3.max_length = 160
		%Area2DAttack1.position = Vector2(160.0, 0)
		%Area2DAttack2.position = Vector2(160.0, 0)
		%Area2DAttack3.position = Vector2(160.0, 0)
	elif _current_weapon_modifier == Core.WeaponModifier.CLUSTER:
		%Laser2D1.max_length = 96
		%Laser2D2.max_length = 96
		%Laser2D3.max_length = 96
		%Area2DAttack1.position = Vector2(96.0, 0)
		%Area2DAttack2.position = Vector2(96.0, 0)
		%Area2DAttack3.position = Vector2(96.0, 0)
	else:
		%Laser2D1.max_length = 128
		%Laser2D2.max_length = 128
		%Laser2D3.max_length = 128
		%Area2DAttack1.position = Vector2(128.0, 0)
		%Area2DAttack2.position = Vector2(128.0, 0)
		%Area2DAttack3.position = Vector2(128.0, 0)
		
	start_jorb()

func _update_weapon_modifier() -> void:
	pass

func _physics_process(delta_: float) -> void:
	super._physics_process(delta_)

	if not is_running():
		return

	if _jorb_active:
		if not is_equal_approx(%Jorb.scale.x, 1.0):
			%Jorb.scale = %Jorb.scale.move_toward(Vector2(1.0, 1.0), show_speed * delta_)
		else:
			%Sprite2D.material.set_shader_parameter(&"offset", %Jorb.global_position / -(32 * PI) / global_scale.x)
			%Jorb.position = $Path2D.curve.get_point_position(0)
			
			if _current_weapon_modifier == Core.WeaponModifier.SPEED:
				progress += movement_speed_fast * delta_
				
				%Laser2D1.rotation_degrees += rotate_speed_fast * delta_
				%Laser2D2.rotation_degrees += rotate_speed_fast * delta_
				%Laser2D3.rotation_degrees += rotate_speed_fast * delta_
			else:
				progress += movement_speed * delta_
				
				%Laser2D1.rotation_degrees += rotate_speed * delta_
				%Laser2D2.rotation_degrees += rotate_speed * delta_
				%Laser2D3.rotation_degrees += rotate_speed * delta_
			
			progress = min(progress, %Path2D.curve.get_baked_length())
			var position_: Vector2 = %Path2D.curve.sample_baked(progress, true)
			%Jorb.global_position = %Path2D.to_global(position_)

			if progress == %Path2D.curve.get_baked_length():
				stop_jorb()
				stop_lasers()
			elif not is_on_solid:
				start_lasers()
			else:
				stop_lasers()
	elif %Jorb.visible:
		if not is_equal_approx(%Jorb.scale.x, 0.1):
			%Jorb.scale = %Jorb.scale.move_toward(Vector2(0.1, 0.1), hide_speed * delta_)
		else:
			%Jorb.visible = false
			# Manually trigger completion
			_attack_cooldown.delta = _attack_cooldown.current_delta + 0.25

func start_lasers() -> void:
	if %Laser2D1.is_on:
		return
		
	%Laser2D1.start()
	%Laser2D2.start()
	%Laser2D3.start()
	
	%Laser2D1.rotation_degrees = 0.0
	%Laser2D2.rotation_degrees = 120.0
	%Laser2D3.rotation_degrees = 240.0
	
	%Area2DAttack1.monitorable = true
	%Area2DAttack1.monitoring = true
	%Area2DAttack2.monitorable = true
	%Area2DAttack2.monitoring = true
	%Area2DAttack3.monitorable = true
	%Area2DAttack3.monitoring = true
	
func stop_lasers() -> void:
	if not %Laser2D1.is_on:
		return
		
	%Laser2D1.stop()
	%Laser2D2.stop()
	%Laser2D3.stop()
	
	%Area2DAttack1.monitorable = false
	%Area2DAttack1.monitoring = false
	%Area2DAttack2.monitorable = false
	%Area2DAttack2.monitoring = false
	%Area2DAttack3.monitorable = false
	%Area2DAttack3.monitoring = false

func _update_path() -> void:
	%Path2D.curve.clear_points()

	for index_: int in target_points.size():
		var point_: Vector2 = to_local(target_points[index_])

		if index_ == 0 or index_ == target_points.size() - 1:
			%Path2D.curve.add_point(point_)
		else:
			var prev_point_: Vector2 = target_points[index_ - 1]
			var next_point_: Vector2 = target_points[index_ + 1]

			var in_direction_: Vector2 = (point_ - prev_point_).normalized()
			var out_direction_: Vector2 = (next_point_ - point_).normalized()
			var tangent: Vector2 = (in_direction_ + out_direction_).normalized()

			var in_: Vector2 = -tangent * path_smoothness
			var out_: Vector2 = tangent * path_smoothness

			%Path2D.curve.add_point(point_, in_, out_)

func start_jorb() -> void:
	%Jorb.position = %Path2D.curve.get_point_position(0)
	progress = 0.0
	%Jorb.scale = Vector2(0.1, 0.1)
	%Jorb.visible = true
	_jorb_active = true

func stop_jorb() -> void:
	_jorb_active = false

func _on_area_2d_solid_body_entered(_body: Node2D) -> void:
	is_on_solid = true

func _on_area_2d_solid_body_exited(_body: Node2D) -> void:
	is_on_solid = false
