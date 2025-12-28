extends BaseUI

func _init() -> void:
	super._init(&"lose")
	
func _ready() -> void:
	_update_button_visibility()

func show_ui() -> void:
	super.show_ui()
	
	Core.audio.play_sfx(&"ui/lose")
	_update_button_visibility()
	
	if Core.level != null:
		%UILabelTimeValue.text = Core.format_time(Core.level.get_play_time())
	else:
		%UILabelTimeValue.text = Core.format_time(0)
	
func _update_button_visibility() -> void:
	if not Core.ENABLE_GAME_DIFFICULTY:
		%UIButtonTryAgainEasy.visible = false
		%UIButtonTryAgainNormal.visible = false
	elif Core.game_difficulty == Core.GameDifficulty.EASY:
		%UIButtonTryAgainEasy.visible = false
		%UIButtonTryAgainNormal.visible = false
	elif Core.game_difficulty == Core.GameDifficulty.NORMAL:
		%UIButtonTryAgainEasy.visible = true
		%UIButtonTryAgainNormal.visible = false
	else:
		%UIButtonTryAgainEasy.visible = false
		%UIButtonTryAgainNormal.visible = true

func _on_ui_button_try_again_pressed() -> void:
	Core.game.restart()

func _on_ui_button_try_again_easy_pressed() -> void:
	Core.game_difficulty = Core.GameDifficulty.EASY
	Core.game.restart()

func _on_ui_button_try_again_normal_pressed() -> void:
	Core.game_difficulty = Core.GameDifficulty.NORMAL
	Core.game.restart()
