extends TowerDefenceEnemyUnit

func _init() -> void:
	super._init(&"enemy_fish")
	
	movement_speed = 100
	
func _ready() -> void:
	super._ready()
