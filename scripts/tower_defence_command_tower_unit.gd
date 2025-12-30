extends BaseUnit 
class_name TowerDefenceCommandTowerUnit

var damage: BaseActor:
	get:
		return actors.use(&"damage")
		
var health: BaseActor:
	get:
		return actors.use(&"health")
		
var life: BaseActor:
	get:
		return actors.use(&"life")

var win: BaseActor:
	get:
		return actors.use(&"win")

var lose: BaseActor:
	get:
		return actors.use(&"lose")
		
func _init(alias_: StringName) -> void:
	super._init(alias_, Core.UnitType.FRIEND)
	
	actors = ActorHandler.new(self)
	actors.add_all({
		&"damage": DamageActor.new(self),
		&"health": HealthActor.new(self),
		&"life": LifeActor.new(self),
		&"lose": LoseActor.new(self),
		&"win": WinActor.new(self),
	})

	actions = ActionHandler.new(self)
	alignment = Core.Alignment.CENTER_CENTER
	
func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		unit_mode = Core.UnitMode.NORMAL
