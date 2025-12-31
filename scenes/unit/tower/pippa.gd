extends TowerDefenceTowerUnit

var target_set: bool = false

var has_semi_automatic: bool = false
var has_machine_gun: bool = false
var equiped_weapon: StringName = &"pistol"

func _init() -> void:
	super._init(&"pippa")
	
func _ready() -> void:
	super._ready()
	
	%Weapon.bullet_after.connect(_on_bullet_after)
	
func _on_bullet_after(weapon_: WeaponUnit, attack_: AttackValue) -> void:
	if attack_.meta.weapon_attack_alias == &"pistol":
		%PippaAnimations.play(&"pistol_use")
	elif attack_.meta.weapon_attack_alias == &"semi_automatic":
		%PippaAnimations.play(&"semi_automatic_use")
	elif attack_.meta.weapon_attack_alias == &"machine_gun":
		%PippaAnimations.play(&"machine_gun_use")
	
func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		target_set = false

		has_semi_automatic = false
		has_machine_gun = false
		equiped_weapon = &"pistol"
		%PippaAnimations.play(&"pistol_idle")
		
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
