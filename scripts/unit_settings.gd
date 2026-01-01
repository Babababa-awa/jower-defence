extends Resource
class_name UnitSettings

@export_group("Attack Modifiers")
@export var attack_slow: bool = false
@export var attack_stun: bool = false
@export var attack_poison: bool = false
@export var poison_damage: float = 10.0

@export_group("Damage Modifiers")
@export var damage_heavy: Core.DamageEffect = Core.DamageEffect.NONE
@export var damage_piercing: Core.DamageEffect = Core.DamageEffect.NONE
@export var damage_explosive: Core.DamageEffect = Core.DamageEffect.NONE
