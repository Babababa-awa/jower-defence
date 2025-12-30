extends TowerDefenceTowerUnit

var target_set: bool = false

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
	
	if target_set:
		%Weapon.attack_from_alias(equiped_weapon)

func set_weapon_target(points_: PackedVector2Array) -> void:
	target_set = true
	%Weapon.target_position = points_[points_.size() - 1]
