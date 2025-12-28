extends BaseUI

@onready var sprite_title: AnimatedSprite2D = $MarginContainer/AnimatedSprite2DTitle

func _init() -> void:
	super._init(&"menu")

func _ready() -> void:
	super._ready()
	_update_title_position()
	_update_locale()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_update_title_position()
		
func _update_title_position() -> void:
	if not sprite_title:
		return
		
	var available_space_: Vector2 = get_viewport().get_visible_rect().size
	
	sprite_title.position = Vector2(round(available_space_.x / 2), 32.0)
		
func _update_locale() -> void:
	sprite_title.play(Core.locale)
	
	if Core.locale == "jp":
		%UIButtonToggleLocale.text = "BUTTON_LOCALE:en"
	else:
		%UIButtonToggleLocale.text = "BUTTON_LOCALE:jp"

func _on_button_toggle_locale_pressed() -> void:
	if TranslationServer.get_locale() == "en" or TranslationServer.get_locale().substr(0, 3) == "en_":
		Core.locale = "jp"
		TranslationServer.set_locale("jp")
	else:
		Core.locale = "en"
		TranslationServer.set_locale("en")
		
	_update_locale()
	
	Core.settings.save()
