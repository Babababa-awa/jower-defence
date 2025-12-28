extends TowerDefenceTowerUnit

var target_set: bool = false

func _init() -> void:
	super._init(&"pippa")

func _process(delta_: float) -> void:
	super._process(delta_)
		
	if not is_running():
		return
	
	if is_placing:
		return
	
		
	%Gun.attack()
		
	
