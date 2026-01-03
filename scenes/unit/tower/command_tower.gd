extends TowerDefenceCommandTowerUnit

@export var sakana_offset: Vector2 = Vector2.ZERO
var _sakana: Node2D = null

func _init() -> void:
	super._init(&"sakana")

	health.max_health = 1000
	#life.lose_on_kill = true

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		_sakana = await Core.nodes.get_node("res://scenes/unit/tower/sakana.tscn")
		_sakana.global_position = %CommandTower.position + sakana_offset
		_sakana.play(&"idle")
	elif reset_type_ == Core.ResetType.STOP:
		Core.nodes.free_node(_sakana)

func ready() -> void:
	super.ready()
	health.damage_after.connect(_on_damage_after)
	life.kill_after.connect(_on_kill_after)
	
func _process(delta_: float) -> void:
	super._process(delta_)
	
	if not is_running():
		return

func _on_damage_after(damage: float) -> void:
	Core.hud.get_hud(&"command_tower_health").refresh()
	
func _on_kill_after() -> void:
	_sakana.play(&"dead")
