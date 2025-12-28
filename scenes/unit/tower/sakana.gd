extends PlayerUnit

func _init() -> void:
	super._init(&"sakana")
		
	jump.is_enabled_default = false
	climb.is_enabled_default = false
	fall.is_enabled_default = false
	weapons.is_enabled_default = false
	life.is_enabled_default = false
	
	alignment = Core.Alignment.CENTER_CENTER
