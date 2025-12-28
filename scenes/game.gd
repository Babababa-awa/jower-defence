extends BaseGame
class_name Game

var day_night_cycle: DayNightCycle = null

func _ready() -> void:
	day_night_cycle = %DayNightCycle

	super._ready()

func add_level_child(node: Node2D) -> void:
	if node is TowerDefenceEnemyUnit:
		%Enemies.add_child(node)
	elif node is TowerDefenceTowerUnit:
		%Towers.add_child(node)
	else:
		super.add_level_child(node)
