extends ProjectileUnit
class_name TowerDefenceProjectileUnit
		
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

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		attack_modifier = Core.AttackModifier.NONE
		previous_attack_modifier = Core.AttackModifier.NONE
		_update_attack_modifier()
		
		damage_modifier = Core.DamageModifier.NONE
		previous_damage_modifier = Core.DamageModifier.NONE
		_update_damage_modifier()

func _update_attack_modifier() -> void:
	%Area2DAttack.meta.set(&"attack_modifier", attack_modifier)

func _update_damage_modifier() -> void:
	%Area2DAttack.meta.set(&"damage_modifier", damage_modifier)
