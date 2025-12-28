extends BaseUnit
class_name TowerDefenceTowerUnit

var is_placing: bool = false

func _init(alias_: StringName) -> void:
	super._init(alias_, Core.UnitType.FRIEND)
	
	alignment = Core.Alignment.CENTER_CENTER
	
func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)

func _physics_process(delta_: float) -> void:
	super._physics_process(delta_)
	
	if not is_running():
		return
		
	if is_placing:
		var position_: Vector2 = get_global_mouse_position() + (Vector2(Core.TILE_SIZE, Core.TILE_SIZE) / 2)
		var coords_: Vector2i = ((position_ / Core.TILE_SIZE).floor() * Core.TILE_SIZE)
		global_position = coords_
		
		if Core.level.can_place_tower_at_coords(coords_):
			%PlaceAnimation.play(&"success")
		else:
			%PlaceAnimation.play(&"error")
		
func start_place() -> void:
	is_placing = true
	%PlaceAnimation.visible = true
	%PlaceAnimation.play(&"error")

func stop_place() -> void:
	is_placing = false
	%PlaceAnimation.visible = false
