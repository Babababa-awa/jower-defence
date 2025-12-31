extends TowerDefenceProjectileUnit

var speed: float = 600
var direction: float = 0.0
var _can_collide: bool = false
var _collision_mask_default: int

func _init() -> void:
	super._init(&"bullet", Core.ProjectileType.BULLET, 10.0)
	
	_collision_mask_default = collision_mask

func _start_death() -> void:
	%AnimatedSprite2D.visible = false

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or 
		reset_type_ == Core.ResetType.RESTART
	):
		_can_collide = false
		collision_mask = 0
		%AnimatedSprite2D.visible = true
		
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if not is_running():
		return
	
	velocity = Vector2(0, -speed).rotated(deg_to_rad(direction))

	move_and_slide()
	
func _handle_collision(delta_: float) -> void:
	# Prevent projectile from colliding with wall until off of wall
	if _current_collision_delta > collision_delta:
		is_colliding = get_slide_collision_count() > 0
		if _can_collide and is_colliding:
			is_dead = true
	else:
		_current_collision_delta += delta_

func _on_area_2d_solid_body_exited(_body: Node2D) -> void:
	_can_collide = true
	collision_mask = _collision_mask_default
