extends PlayerUnit

func _init() -> void:
	super._init(&"camera")
	
	collision.is_enabled_default = false
	damage.is_enabled_default = false
	jump.is_enabled_default = false
	climb.is_enabled_default = false
	fall.is_enabled_default = false
	weapons.is_enabled_default = false
	life.is_enabled_default = false
	
	alignment = Core.Alignment.CENTER_CENTER
	
	move.normal_move_speed = 1200.0
	move.normalize_move_speed = true
