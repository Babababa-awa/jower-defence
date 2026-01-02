extends TowerDefenceEnemyUnit

func _init() -> void:
	super._init(&"enemy_1")
	
	movement_speed = 150
	
func _ready() -> void:
	super._ready()
