extends EnemyUnit
class_name TowerDefenceEnemyUnit

var movement_speed: float = 500
var kill_money: int = 5
var path: Path2D = null
var progress: float = 0.0

func _init(alias_: StringName) -> void:
	super._init(alias_)
	
	climb.is_enabled_default = false
	fall.is_enabled_default = false
	weapons.is_enabled_default = false
	life.is_enabled_default = false
	move.is_enabled_default = false
	
	alignment = Core.Alignment.CENTER_CENTER
	
func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		progress = 0.0
	elif reset_type_ == Core.ResetType.STOP:
		path = null

func _physics_process(delta_: float) -> void:
	super._physics_process(delta_)
	
	if path == null:
		return
		
	progress += movement_speed * delta_
	progress = min(progress, path.curve.get_baked_length())
	var position_: Vector2 = path.curve.sample_baked(progress, true)
	global_position = path.to_global(position_)
	
	if progress == path.curve.get_baked_length():
		path = null
		Core.nodes.free_node(self)
	
func set_path(path_: Path2D) -> void:
	if path_ == null or path_.curve == null or path_.curve.get_baked_length() == 0:
		path = null
	else:
		path = path_
		position = path_.curve.get_baked_points()[0]
