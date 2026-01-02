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
			
@export var particles_color: Color = Color.WHITE:
	set(value):
		particles_color = value
		
		if get_node_or_null("%GPUParticles2DCollision") != null:
			%GPUParticles2DCollision.modulate = value
			
		if get_node_or_null("%GPUParticles2DLaser") != null:
			%GPUParticles2DLaser.modulate = value
			

var _collision_accuracy: float = 8.0
var _current_position: Vector2 = Vector2.ZERO
var _end_position: Vector2 = Vector2.ZERO
var _is_colliding: bool = false

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
	%GPUParticles2DCollision.modulate = particles_color
	%GPUParticles2DLaser.modulate = particles_color
	
	if is_on:
		start()
	else:
		stop()

	if not Engine.is_editor_hint():
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	_end_position = get_end_position()
	
	_current_position = _current_position.move_toward(
		Vector2(max_length, 0), 
		beam_speed * delta
	)

	var end_position_: Vector2 = _current_position
	
	if end_position_.x > _end_position.x:
		end_position_ = _end_position
		_is_colliding = true
	
	if _is_colliding or shot_length > 0:
		%GPUParticles2DCollision.position = end_position_ + Vector2(beam_width / 2, 0)
		%GPUParticles2DCollision.rotation_degrees = 180
		%GPUParticles2DCollision.emitting = true
	else:
		%GPUParticles2DCollision.emitting = false
	
	%Line2D.points[1] = end_position_
		
	if shot_length > 0:
		if _is_colliding or end_position_.x == max_length:
			%Line2D.points[0].x = max(%Line2D.points[0].x + (beam_speed * delta), end_position_.x)
		elif end_position_.x - start_offset > shot_length:
			%Line2D.points[0].x = max(start_offset, end_position_.x - shot_length)

		if %Line2D.points[0].x == %Line2D.points[1].x:
			stop()
	else:
		%GPUParticles2DLaser.position = Vector2(start_offset, 0) + ((end_position_ - %Line2D.points[0]) / 2)
		%GPUParticles2DLaser.process_material.emission_box_extents.x = end_position_.distance_to(%Line2D.points[0]) / 2

func get_end_position() -> Vector2:
	var x_: float = 0
	
	var is_in_solid_: bool = true
	
	while (true):
		%RayCast2D.position = Vector2(x_, 0)
		%RayCast2D.target_position = Vector2(x_ + _collision_accuracy, 0)
		%RayCast2D.force_raycast_update()

		var has_solid_: bool = false
		
		var collision_point_: Vector2 = %RayCast2D.get_collision_point()
		var collider_: Node2D = %RayCast2D.get_collider()
		
		if collider_ is TileMapLayer:
			var tile_coords_: Vector2i = collider_.local_to_map(
				collider_.to_local(collision_point_)
			)
			var tile_data_: TileData = collider_.get_cell_tile_data(tile_coords_)
			
			if tile_data_ == null:
				continue
			
			if tile_data_.get_collision_polygons_count(0):
				has_solid_ = true

		if not has_solid_:
			is_in_solid_ = false
		elif not is_in_solid_ and has_solid_:
			return Vector2(%RayCast2D.target_position.x - _collision_accuracy, 0)
			
		x_ += _collision_accuracy
		
		if x_ > max_length:
			break
	
	return Vector2(max_length, 0)
	
func start() -> void:
	is_on = true
	_is_colliding = false
	_current_position = Vector2.ZERO
	
	set_physics_process(true)
	
	if shot_length == 0.0:
		%GPUParticles2DLaser.emitting = true
		%GPUParticles2DLaser.position = Vector2(start_offset, 0)
		%GPUParticles2DLaser.process_material.emission_box_extents.x = 0.0

	%Line2D.points[0] = Vector2(start_offset, 0)
	%Line2D.points[1] = Vector2(start_offset, 0)

	_show_laser()

func stop() -> void:
	is_on = false
	
	set_physics_process(false)
	
	%GPUParticles2DLaser.emitting = false
	%GPUParticles2DCollision.emitting = false
	
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
