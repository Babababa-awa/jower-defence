extends PlayerUnit

func _init() -> void:
	super._init(&"camera")
	
	
	interact.is_enabled_default = false
	items.is_enabled_default = false
	collision.is_enabled_default = false
	damage.is_enabled_default = false
	health.is_enabled_default = false
	hunger.is_enabled_default = false
	life.is_enabled_default = false
	lose.is_enabled_default = false
	win.is_enabled_default = false
	crouch.is_enabled_default = false
	jump.is_enabled_default = false
	climb.is_enabled_default = false
	fall.is_enabled_default = false
	weapons.is_enabled_default = false
	
	alignment = Core.Alignment.CENTER_CENTER
	
	move.normal_move_speed = 1200.0
	move.normalize_move_speed = true
