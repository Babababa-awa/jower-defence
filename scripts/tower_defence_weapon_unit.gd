extends WeaponUnit
class_name TowerDefenceWeaponUnit

var owner_group: StringName = &"tower"

var weapon_modifier: Core.WeaponModifier = Core.WeaponModifier.NONE:
	set(value):
		weapon_modifier = value
		if is_node_ready():
			_update_weapon()
		
var projectile_modifier: Core.ProjectileModifier = Core.ProjectileModifier.NONE:
	set(value):
		projectile_modifier = value
		if is_node_ready():
			_update_weapon()
			
var damage_modifier: Core.DamageModifier = Core.DamageModifier.NONE:
	set(value):
		damage_modifier = value
		if is_node_ready():
			_update_weapon()
			
func _update_weapon() -> void:
	pass

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		weapon_modifier = Core.WeaponModifier.NONE
		projectile_modifier = Core.ProjectileModifier.NONE
		damage_modifier = Core.DamageModifier.NONE
		_update_weapon()
