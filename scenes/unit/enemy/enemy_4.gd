extends TowerDefenceEnemyUnit

func _init() -> void:
	super._init(&"enemy_4")
	
	movement_speed = 50
	health.max_health = 4000
	kill_money = 25
	
func _ready() -> void:
	super._ready()
