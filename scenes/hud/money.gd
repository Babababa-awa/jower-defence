extends BaseHUD

var _size: Vector2 = Vector2.ZERO

func _init() -> void:
	super._init(&"money")

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or 
		reset_type_ == Core.ResetType.RESTART or 
		reset_type_ == Core.ResetType.REFRESH
	):
		_update()

func _update() -> void:
	var texture_: Texture2D = %AnimatedSprite2D.sprite_frames.get_frame_texture(
		%AnimatedSprite2D.animation, 
		%AnimatedSprite2D.frame
	)
	var texture_size_: Vector2 = texture_.get_size()
	
	%UILabel.position.x = texture_size_.x + texture_size_.x / 8
	%UILabel.position.y = (texture_size_.y / 2) - (%UILabel.size.y / 2)
	
	_size = Vector2(
		texture_size_.x + (texture_size_.x / 4) + %UILabel.size.y,
		texture_size_.y
	)
	
	rect_changed.emit(self)

func set_money(value_: int) -> void:
	%UILabel.text = str(value_)
	_update()

func get_rect() -> Rect2:
	return Rect2(Vector2.ZERO, _size)
