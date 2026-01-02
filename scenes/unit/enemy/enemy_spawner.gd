extends BaseUnit
class_name EnemySpawner

@export var enemies: Array[UnitSpawner] = []
@export var paths: Node2D = null

var current_delta: float = 0.0

signal spawn(spawner: Node2D, unit: Node2D)

func _init() -> void:
	super._init(&"spawner", Core.UnitType.OBJECT)

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		current_delta = 0.0
		
		for enemy: UnitSpawner in enemies:
			enemy.reset()
			if reset_type_ == Core.ResetType.START:
				enemy.spawn.connect(_on_spawn)
			
	elif reset_type_ == Core.ResetType.STOP:
		for enemy: UnitSpawner in enemies:
			enemy.spawn.disconnect(_on_spawn)
		
func _physics_process(delta_: float) -> void:
	super._physics_process(delta_)
			
	if not is_running():
		return
		
	for enemy: UnitSpawner in enemies:
		enemy.process(delta_)

func _on_spawn(unit_: Node2D) -> void:
	spawn.emit(self, unit_)
