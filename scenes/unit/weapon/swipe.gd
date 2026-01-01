extends TowerDefenceWeaponUnit

func _init() -> void:
	super._init(
		&"swipe", 
		Core.WeaponType.MELEE,
		[
			WeaponAttack.new(&"tail", 1.5),
			WeaponAttack.new(&"bat", 1.5),
			WeaponAttack.new(&"large_bat", 0.2)
		]
	)
	
func _ready() -> void:
	super._ready()
	attack_after.connect(_on_attack_after)

func _on_attack_after(_weapon: WeaponUnit, attack_: AttackValue) -> void:
	pass
	
func _process(delta_: float) -> void:
	super._process(delta_)

	if not is_running():
		return
