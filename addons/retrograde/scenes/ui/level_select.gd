extends BaseUI

func _init() -> void:
	super._init(&"level_select")

func _ready() -> void:
	_update_button_state()

func show_ui() -> void:
	super.show_ui()
	
	_update_button_state()
	
	if Core.level != null and Core.level.level_mode == Core.LevelMode.GAME:		
		%ColorRect.visible = true
	else:
		%ColorRect.visible = false

func _update_button_state() -> void:
	for child_: Node in %GridContainer.get_children():
		if not child_ is UIButton:
			continue
			
		var level: String = str(child_.goto_ui_alias.substr(6))
		if (Core.save.data.has(level) and 
			Core.save.data[level].has("win") and
			Core.save.data[level].win
		):
			_update_button_star(child_, true)
		else:
			_update_button_star(child_, false)

func _update_button_star(button_: UIButton, visible_: bool) -> void:
	for child_: Node in button_.get_children():
		if child_ is TextureRect:
			child_.visible = visible_
			break
