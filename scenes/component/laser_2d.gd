@tool
extends Node2D
class_name Laser2D

@export var start_offset: float = 0.0
@export var shot_length: float = 0.0
@export var max_length: float = 1600.0
@export var beam_speed: float = 8000.0
@export var beam_width: float = 16.0
@export var show_delta: float = 0.2
@export var hide_delta: float = 0.1
@export var color: Color = Color.WHITE:
	set(value):
		color = value
		
		if get_node_or_null("%Line2D") != null:
			%Line2D.modulate = value

var is_on: bool = false: 
	set(value):
		if is_on == value:
			return
		
		is_on = value
		
		if is_on:
			start()
		else:
			stop()

var _tween: Tween = null

func _ready() -> void:
	%Line2D.points[0] = Vector2(start_offset, 0)
	%Line2D.points[1] = Vector2(start_offset, 0)
	%Line2D.visible = false

	%Line2D.modulate = color
	
	if is_on:
		start()
	else:
		stop()

	if not Engine.is_editor_hint():
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	%RayCast2D.target_position = %RayCast2D.target_position.move_toward(
		Vector2(max_length, 0), 
		beam_speed * delta
	)

	var end_position_: Vector2 = %RayCast2D.target_position
	
	%RayCast2D.force_raycast_update()

	if %RayCast2D.is_colliding():
		end_position_ = to_local(%RayCast2D.get_collision_point())
	
	%Line2D.points[1] = end_position_
		
	if shot_length > 0:
		if %RayCast2D.is_colliding() or end_position_.x == max_length:
			%Line2D.points[0].x = max(%Line2D.points[0].x + (beam_speed * delta), end_position_.x)
		elif end_position_.x - start_offset > shot_length:
			%Line2D.points[0].x = max(start_offset, end_position_.x - shot_length)

		if %Line2D.points[0].x == %Line2D.points[1].x:
			stop()
	
func start() -> void:
	is_on = true
	
	set_physics_process(true)

	%Line2D.points[0] = Vector2(start_offset, 0)
	%Line2D.points[1] = Vector2(start_offset, 0)

	_show_laser()

func stop() -> void:
	is_on = false
	
	set_physics_process(false)
	
	%RayCast2D.target_position = Vector2.ZERO
	
	_hide_laser()

func _show_laser() -> void:
	%Line2D.show()
	
	if _tween and _tween.is_running():
		_tween.kill()
		
	_tween = create_tween()
	
	_tween.tween_property(
		%Line2D, 
		"width", 
		beam_width, 
		show_delta
	).from(0.0)

func _hide_laser() -> void:
	if _tween and _tween.is_running():
		_tween.kill()
		
	_tween = create_tween()
	
	_tween.tween_property(
		%Line2D, 
		"width", 
		0.0, 
		hide_delta
	).from_current()
	
	_tween.tween_callback(%Line2D.hide)

func get_points() -> PackedVector2Array:
	return %Line2D.points
