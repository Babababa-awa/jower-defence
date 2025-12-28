extends BaseNode2D

@export var tower: StringName = &"":
	set(value):
		tower = value
		_update()

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or 
		reset_type_ == Core.ResetType.RESTART or 
		reset_type_ == Core.ResetType.REFRESH
	):
		_update()
	
func _update() -> void:
	if Core.level == null or not Core.level is TowerDefenceLevel:
		return
	
	%AnimatedSprite2D.play(tower)
	%UILabel.text = str(Core.level.get_tower_price(tower))
		
	var texture_size_: Vector2 = %Sprite2D.texture.get_size()

	%UILabel.position.x = ((%Sprite2D.position.x - (texture_size_.x / 2)) * 2) + texture_size_.x
	%UILabel.position.y = %Sprite2D.position.y - (%UILabel.size.y / 2) - 2

func _on_area_2d_rect_mouse_entered() -> void:
	pass # Replace with function body.

func _on_area_2d_rect_mouse_exited() -> void:
	pass # Replace with function body.

func _on_area_2d_rect_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Core.level == null or not Core.level is TowerDefenceLevel:
		return
		
	if (event is InputEventMouseButton and 
		event.button_index == MouseButton.MOUSE_BUTTON_LEFT and 
		event.pressed
	):
		Core.level.purchase_tower(tower)
