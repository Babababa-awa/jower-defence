extends TowerDefenceEnemyUnit

func _init() -> void:
	super._init(&"enemy_3")
	
	movement_speed = 150
	
func _ready() -> void:
	super._ready()
