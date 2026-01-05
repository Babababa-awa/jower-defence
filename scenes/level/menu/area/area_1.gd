extends BaseArea

func _init() -> void:
	super._init(&"area_1")
	
func _ready() -> void:
	super._ready()
	%PippaAnimations.play(&"semi_automatic_idle")

func _process(delta_: float) -> void:
	super._process(delta_)
	
	var available_space_: Vector2 = get_viewport().get_visible_rect().size
	available_space_ = available_space_ / Core.MENU_CAMERA_ZOOM
	
	var texture_size: Vector2 = %Sprite2D.texture.get_size()

	var scale_factor: float = max(
		available_space_.x / texture_size.x,
		available_space_.y / texture_size.y
	)

	%Sprite2D.scale = Vector2.ONE * scale_factor

	var sprite_height: float = texture_size.y * scale_factor
	%Sprite2D.position = Vector2(
		0.0,
		(available_space_.y / 2.0) - (sprite_height / 2.0)
	)
