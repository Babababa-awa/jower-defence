@tool
extends BaseNode2D
class_name TargetCone2D

@export var start_point: Vector2 = Vector2.ZERO
@export var radius: float = 256.0
@export var angle_degrees: float = 90.0
@export var color: Color = Color(1, 0, 0, 0.5)
@export var segments: int = 32 
@export var outline_width: float = 8.0
@export var outline_color: Color = Color.RED:
	set(value):
		outline_color = value
		
		if get_node_or_null("%Line2D") != null:
			%Line2D.modulate = value

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
var _target: Vector2 = Vector2.ZERO
var _angle: float = 0.0

signal target_complete(points: PackedVector2Array)
signal target_error(reason_: StringName, error_: Core.Error)

func _draw() -> void:
	if not is_targeting:
		return
		
	var points_: PackedVector2Array = [start_point]
	%Line2D.width = outline_width
	%Line2D.clear_points()
	%Line2D.add_point(start_point)
	
	var start_angle_rad_: float = (_target - start_point).angle() - deg_to_rad(angle_degrees / 2)
	var end_angle_rad_: float = start_angle_rad_ + deg_to_rad(angle_degrees)
	
	for i: int in range(segments + 1):
		var progress_: float = float(i) / segments
		var current_angle_rad_: float = lerp(start_angle_rad_, end_angle_rad_, progress_)
		var point_: Vector2 = start_point + Vector2.from_angle(current_angle_rad_) * radius
		points_.append(point_)
		%Line2D.add_point(point_)
	
	draw_colored_polygon(points_, color)
	
	if outline_width > 0:
		%Line2D.visible = true
	else:
		%Line2D.visible = false

func _input(event: InputEvent) -> void:
	if (is_targeting and
		set_target_delay > Core.MIN_COLLISION_WAIT_DELTA and
		event is InputEventMouseButton and 
		event.pressed
	):
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			is_targeting = false
			var points_: PackedVector2Array = [_target]
			target_complete.emit(points_)
		elif event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			is_targeting = false
			target_error.emit(&"canceled", Core.Error.CANCELED)
			
func _physics_process(delta_: float) -> void:
	super._physics_process(delta_)
	
	if not is_running():
		return
		
	if is_targeting:
		set_target_delay += delta_
		
		_target = get_local_mouse_position()
		_angle = rad_to_deg((_target - start_point).angle())
		queue_redraw()
	
func start_targeting() -> void:
	set_physics_process(true)
	
	set_target_delay = 0.0
	
	_target = get_local_mouse_position()
	_angle = rad_to_deg((_target - start_point).angle())
	%Line2D.visible = true

func stop_targeting() -> void:
	set_physics_process(false)

	%Line2D.visible = false
	queue_redraw()
