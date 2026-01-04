extends TowerDefenceEnemyUnit

func _init() -> void:
	super._init(&"enemy_2")
	
	movement_speed = 125
	health.max_health = 450
	kill_money = 5
	
func _ready() -> void:
	super._ready()
