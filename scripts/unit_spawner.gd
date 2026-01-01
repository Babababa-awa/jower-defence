extends Resource
class_name UnitSpawner

@export var unit: PackedScene = null
@export var spawn_rate: float = 4
@export var count: int = -1
@export var delay: float = 0

@export_group("Unit Settings")
@export var unit_settings: UnitSettings = UnitSettings.new()

var current_delta: float = 0.0
var total_delta: float = 0.0

signal spawn(unit: Node2D)

func reset() -> void:
	current_delta = 0.0
	total_delta = 0.0

func process(delta_: float) -> void:
	if unit == null:
		return
		
	if total_delta >= delay:
		if current_delta <= 0.0:
			spawn_unit()
			current_delta = spawn_rate + current_delta
		
		current_delta -= delta_
	
	total_delta += delta_
		
func spawn_unit() -> void:
	var unit_: Node2D = await Core.nodes.get_node(unit.resource_path)
	unit_.unit_settings = unit_settings
	spawn.emit(unit_)
