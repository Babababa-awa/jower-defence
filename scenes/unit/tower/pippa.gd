extends TowerDefenceTowerUnit

var target_set: bool = false

var has_semi_automatic: bool = false
var has_machine_gun: bool = false
var equiped_weapon: StringName = &"pistol"

func _init() -> void:
	super._init(&"pippa")
	
func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		target_set = false

		has_semi_automatic = false
		has_machine_gun = false
		equiped_weapon = &"pistol"
		
func _process(delta_: float) -> void:
	super._process(delta_)
		
	if not is_running():
		return
	
	if is_placing:
		return
	
	if target_set:
		%Gun.attack_from_alias(equiped_weapon)
	
	if is_targeting:
		%Line2DTarget.points[1] = get_local_mouse_position()


func set_target() -> void:
	super.set_target()
	
	if is_targeting:
		if %Line2DTarget.points.size() == 0:
			%Line2DTarget.add_point(Vector2.ZERO)
			%Line2DTarget.add_point(get_local_mouse_position())
		%Line2DTarget.visible = true

func set_weapon_target(position_: Vector2) -> void:
	target_set = true
	%Gun.target_position = position_
	%Line2DTarget.visible = false

func cancel_weapon_target() -> void:
	%Line2DTarget.visible = false
