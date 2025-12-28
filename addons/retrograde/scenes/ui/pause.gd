extends BaseUI

func _init() -> void:
	super._init(&"pause")
	
func _ready() -> void:
	_update_button_visibility()
	
func show_ui() -> void:
	super.show_ui()
	
	_update_button_visibility()
	
	if Core.level != null:
		%UILabelTimeValue.text = Core.format_time(Core.level.get_play_time())
	else:
		%UILabelTimeValue.text = Core.format_time(0)

func _update_button_visibility() -> void:
	if (Core.ENABLE_LEVEL_SELECT and 
		Core.ENABLE_LEVEL_SKIP and
		Core.level and
		Core.level_select.has_next_level(Core.level.alias)
	):
		%UIButtonSkipLevel.visible = true
	else:
		%UIButtonSkipLevel.visible = false
	
func _on_ui_button_continue_pressed() -> void:
	hide_ui()
	Core.game.toggle_pause()


func _on_ui_button_restart_pressed() -> void:
	hide_ui()
	Core.game.restart()

func _on_ui_button_skip_level_pressed() -> void:
	if not Core.level_select.has_next_level(Core.level.alias):
		return
		
	var level_: StringName = Core.level_select.get_next_level(Core.level.alias)
	if level_ != &"":
		Core.game.start_level(level_)
