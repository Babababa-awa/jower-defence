extends TowerDefenceCommandTowerUnit

func _init() -> void:
	super._init(&"sakana")

	health.max_health = 1000
	life.lose_on_kill = true

func ready() -> void:
	super.ready()
	health.damage_after.connect(_on_damage_after)
	
func _process(delta_: float) -> void:
	super._process(delta_)
	
	if not is_running():
		return

func _on_damage_after(damage: float) -> void:
	Core.hud.get_hud(&"command_tower_health").refresh()
