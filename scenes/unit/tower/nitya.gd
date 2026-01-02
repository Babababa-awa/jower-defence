extends TowerDefenceTowerUnit

var target_set: bool = false

var has_bat: bool = false
var has_large_bat: bool = false
var equiped_weapon: StringName = &"tail":
	set(value):
		equiped_weapon = value
		_update_target_cone()

func _init() -> void:
	super._init(&"nitya")

func _ready() -> void:
	super._ready()
	
	%Weapon.attack_after.connect(_on_attack_after)
	%NityaAnimations.animation_finished.connect(_on_animation_finished)

func _on_attack_after(_weapon: WeaponUnit, attack_: AttackValue) -> void:
	if attack_.meta.weapon_attack_alias == &"tail":
		%NityaAnimations.play("tail_use")
	elif attack_.meta.weapon_attack_alias == &"bat":
		%NityaAnimations.play("bat_use")
	elif attack_.meta.weapon_attack_alias == &"large_bat":
		%NityaAnimations.play("large_bat_use")
		
func _on_animation_finished() -> void:
	if equiped_weapon == &"tail":
		%NityaAnimations.play("tail_idle")
	elif equiped_weapon == &"bat":
		%NityaAnimations.play("bat_idle")
	elif equiped_weapon == &"large_bat":
		%NityaAnimations.play("large_bat_idle")
		
func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		target_set = false

		has_bat = false
		has_large_bat = false
		equiped_weapon = &"tail"
		%NityaAnimations.play(&"tail_idle")
		
func _process(delta_: float) -> void:
	super._process(delta_)
		
	if not is_running():
		return
	
	if is_placing:
		return
	
	if target_set:
		%Weapon.attack_from_alias(equiped_weapon)

func _update_target_cone() -> void:
	if equiped_weapon == &"tail":
		%TargetCone2D.radius = 352
		%TargetCone2D.angle_degrees = 22.5
	elif equiped_weapon == &"bat":
		%TargetCone2D.radius = 352
		%TargetCone2D.angle_degrees = 60.0
	elif equiped_weapon == &"large_bat":
		%TargetCone2D.radius = 408
		%TargetCone2D.angle_degrees = 135.0

func set_weapon_target(points_: PackedVector2Array) -> void:
	target_set = true
	
	var target_position_: Vector2 = points_[points_.size() - 1]
	
	if target_position_.x < 0:
		%NityaAnimations.flip_h = true
	else:
		%NityaAnimations.flip_h = false
		
	%Weapon.target_position = to_global(target_position_)
