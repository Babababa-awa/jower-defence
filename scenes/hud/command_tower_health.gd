extends BaseHUD

func _init() -> void:
	super._init(&"command_tower_health")

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or 
		reset_type_ == Core.ResetType.RESTART or 
		reset_type_ == Core.ResetType.REFRESH
	):
		_update()
		
func _update() -> void:
	var command_tower_: TowerDefenceCommandTowerUnit = Core.game.get_command_tower()
	
	if command_tower_ == null:
		Core.hud.hide_hud(&"command_tower_health")
		return
	
	Core.hud.show_hud(&"command_tower_health")

	var health_actor: HealthActor = command_tower_.health
	
	# 768 = width of bar, -8 with borders
	var x: float = round(760.0 * health_actor.health / health_actor.max_health)
	
	%Line2DCurrent.points[1].x = x
	
func get_rect() -> Rect2:
	return Rect2(Vector2.ZERO, Vector2(768, 64))
