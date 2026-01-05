extends BaseHUD

var _size: Vector2 = Vector2.ZERO

func _init() -> void:
	super._init(&"start")

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
	
	%UILabel.position.x = (texture_size_.x / 2) - (%UILabel.size.x / 2)
	%UILabel.position.y = texture_size_.y  - %UILabel.size.y - 5
	
	_size = texture_size_
	
	rect_changed.emit(self)

func get_rect() -> Rect2:
	return Rect2(Vector2.ZERO, _size)


func _on_area_2d_mouse_entered() -> void:
	%AnimatedSprite2D.play(&"hover")

func _on_area_2d_mouse_exited() -> void:
	%AnimatedSprite2D.play(&"default")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Core.level == null or not Core.level is TowerDefenceLevel:
		return
		
	if (event is InputEventMouseButton and 
		event.button_index == MouseButton.MOUSE_BUTTON_LEFT and 
		event.pressed
	):
		Core.audio.play_sfx(&"click")
		Core.level.start_game()
