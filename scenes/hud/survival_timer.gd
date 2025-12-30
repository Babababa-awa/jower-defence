extends BaseHUD

var _size: Vector2 = Vector2.ZERO

var survival_time_seconds: int = 0

func _init() -> void:
	super._init(&"survival_timer")

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or 
		reset_type_ == Core.ResetType.RESTART or 
		reset_type_ == Core.ResetType.REFRESH
	):
		_update()
		
func set_survival_time(survival_time_seconds_: int) -> void:
	survival_time_seconds = survival_time_seconds_
	_update()

func _update() -> void:
	if not Core.level is TowerDefenceLevel or survival_time_seconds == 0:
		%UILabel.text = "00:00"
	else:
		var play_time_: int = roundi(float(Core.level.get_play_time()) / 1000)
		var remaining_seconds_: int = survival_time_seconds - play_time_
		
		var hours: int = floori(remaining_seconds_ / 3600.0)
		var minutes: int = floori((remaining_seconds_ % 3600) / 60.0)
		var seconds: int = remaining_seconds_ % 60
		
		if hours > 0:
			%UILabel.text = "%d:%02d:%02d" % [hours, minutes, seconds]
		else:
			%UILabel.text = "%2d:%02d" % [minutes, seconds]
		
	%UILabel.position = Vector2(
		256 - %UILabel.size.x,
		(64 - %UILabel.size.y) / 2
	)

func _on_timer_timeout() -> void:
	_update()

func get_rect() -> Rect2:
	return Rect2(Vector2.ZERO, Vector2(256, 64))
