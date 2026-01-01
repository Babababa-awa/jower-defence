extends TowerDefenceTowerUnit

var target_set: bool = false
var jorb_target_set: bool = false

var has_laser_beam: bool = false
var has_jorb: bool = false
var equiped_weapon: StringName = &"laser_shot"

func _init() -> void:
	super._init(&"jelly")

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		target_set = false

		has_laser_beam = false
		has_jorb = false
		equiped_weapon = &"laser_shot"
		
func _process(delta_: float) -> void:
	super._process(delta_)
		
	if not is_running():
		return
	
	if is_placing:
		return
	
	if equiped_weapon == &"jorb":
		if %Weapon.current_attack_value != null:
			%Weapon.clear_queue()
		else:
			if jorb_target_set:
				%Weapon2.attack()
			elif not %TargetLine2D.is_targeting and not Core.game.is_tower_command_visible():
				set_target()
	elif target_set:
		if %Weapon2.current_attack_value != null:
			%Weapon2.clear_queue()
		else:
			%Weapon.attack_from_alias(equiped_weapon)


func set_target() -> void:
	if equiped_weapon == &"jorb":
		jorb_target_set = false
		%TargetLine2D.max_points = 4
		%Weapon2.stop_jorb()
	else:
		target_set = false
		%TargetLine2D.max_points = 2
		
	super.set_target()

func set_weapon_target(points_: PackedVector2Array) -> void:
	if equiped_weapon == &"jorb":
		jorb_target_set = true
		
		var global_points_: PackedVector2Array = []
		for point_: Vector2 in points_:
			global_points_.append(to_global(point_))
			
		%Weapon2.target_points = global_points_
	else:
		target_set = true
		%Weapon.target_position = to_global(points_[points_.size() - 1])
