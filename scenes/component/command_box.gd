extends BaseNode2D
class_name CommandBox

signal closed(command_box_: CommandBox)

func _on_visibility_changed() -> void:
	if not visible or not get_parent().visible:
		return
		
	refresh()
	
	Core.game.set_mouse_action(&"command_box_hover")

func refresh() -> void:
	var top_: float = 12
	
	for child_: Node in get_children():
		if child_ is CommandButton:
			if not child_.visible:
				continue
			child_.position = Vector2(12, top_)
			top_ += 52

	top_ += 8
	
	%NinePatchRect.position.x = 0
	%NinePatchRect.size = Vector2(272, top_)
	%Area2DCommandBox.position = Vector2(136, top_ / 2)
	%CollisionShape2D.shape.size = Vector2(272, top_)
	
func _on_area_2d_command_box_mouse_entered() -> void:
	Core.game.set_mouse_action(&"command_box_hover")

func _on_area_2d_command_box_mouse_exited() -> void:
	Core.game.clear_mouse_action(&"command_box_hover", true)

func _on_area_2d_command_box_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton and 
		event.button_index == MouseButton.MOUSE_BUTTON_RIGHT and 
		event.pressed
	):
		if (Core.game.mouse_action == &"command_button_hover" or
			Core.game.mouse_action == &"command_box_hover"
		):
			closed.emit(self)
