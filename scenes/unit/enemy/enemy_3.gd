extends TowerDefenceEnemyUnit

func _init() -> void:
	super._init(&"enemy_3")
	
	movement_speed = 175
	health.max_health = 1000
	kill_money = 5
	
func _ready() -> void:
	super._ready()
