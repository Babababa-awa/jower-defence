extends BaseNode2D
class_name TargetLine2D

@export var start_point: Vector2 = Vector2.ZERO
@export var color: Color = Color.RED:
	set(value):
		color = value
		
		if get_node_or_null("%Line2D") != null:
			%Line2D.modulate = value
			
@export var max_points: int = 2

var is_targeting: bool = false: 
	set(value):
		if is_targeting == value:
			return
		
		is_targeting = value
		
		if is_targeting:
			start_targeting()
		else:
			stop_targeting()

var set_target_delay: float = 0.0

signal target_point(points: PackedVector2Array)
signal target_complete(points: PackedVector2Array)
signal target_error(reason_: StringName, error_: Core.Error)

func _ready() -> void:
	super._ready()
	
	%Line2D.modulate = color

func _input(event: InputEvent) -> void:
	if (is_targeting and
		set_target_delay > Core.MIN_COLLISION_WAIT_DELTA and
		event is InputEventMouseButton and 
		event.pressed
	):
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if %Line2D.points.size() == max_points:
				is_targeting = false
				target_complete.emit(%Line2D.points)
			else:
				%Line2D.add_point(get_global_mouse_position())
				target_point.emit(%Line2D.points)
		elif event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			is_targeting = false
			target_error.emit(&"canceled", Core.Error.CANCELED)
			
func _physics_process(delta_: float) -> void:
	super._physics_process(delta_)
	
	if not is_running():
		return
		
	if is_targeting:
		set_target_delay += delta_
		
		%Line2D.points[%Line2D.points.size() - 1] = get_local_mouse_position()

func start_targeting() -> void:
	set_physics_process(true)
	
	set_target_delay = 0.0
	
	%Line2D.clear_points()
	%Line2D.add_point(start_point)
	%Line2D.add_point(get_local_mouse_position())
	%Line2D.visible = true

func stop_targeting() -> void:
	set_physics_process(false)

	%Line2D.visible = false
