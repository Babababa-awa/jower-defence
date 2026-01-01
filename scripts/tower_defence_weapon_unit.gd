extends WeaponUnit
class_name TowerDefenceWeaponUnit

var owner_group: StringName = &"tower"

var weapon_modifier: Core.WeaponModifier = Core.WeaponModifier.NONE:
	set(value):
		if weapon_modifier != value:
			previous_weapon_modifier = weapon_modifier
			weapon_modifier = value
			if is_node_ready():
				_update_weapon_modifier()
var previous_weapon_modifier: Core.WeaponModifier = Core.WeaponModifier.NONE
		
var attack_modifier: Core.AttackModifier = Core.AttackModifier.NONE:
	set(value):
		if attack_modifier != value:
			previous_attack_modifier = attack_modifier
			attack_modifier = value
			if is_node_ready():
				_update_attack_modifier()
var previous_attack_modifier: Core.AttackModifier = Core.AttackModifier.NONE
			
var damage_modifier: Core.DamageModifier = Core.DamageModifier.NONE:
	set(value):
		if damage_modifier != value:
			previous_damage_modifier = damage_modifier
			damage_modifier = value
			if is_node_ready():
				_update_damage_modifier()
var previous_damage_modifier: Core.DamageModifier = Core.DamageModifier.NONE

func _update_weapon_modifier() -> void:
	pass

func _update_attack_modifier() -> void:
	pass		

func _update_damage_modifier() -> void:
	pass

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		weapon_modifier = Core.WeaponModifier.NONE
		previous_weapon_modifier = Core.WeaponModifier.NONE
		_update_weapon_modifier()
		
		attack_modifier = Core.AttackModifier.NONE
		previous_attack_modifier = Core.AttackModifier.NONE
		_update_attack_modifier()
		
		damage_modifier = Core.DamageModifier.NONE
		previous_damage_modifier = Core.DamageModifier.NONE
		_update_damage_modifier()
