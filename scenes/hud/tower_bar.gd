extends BaseHUD

var _size: Vector2 = Vector2.ZERO

@onready var tower_bar_items: Array[BaseNode2D] = [
	%TowerBarItem1,
	%TowerBarItem2,
	%TowerBarItem3,
]

func _init() -> void:
	super._init(&"tower_bar")
	
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
	
	_size = Vector2.ZERO
	
	var available_towers_: Array[StringName] = Core.level.get_available_towers()

	for i: int in tower_bar_items.size():
		if i < available_towers_.size():
			tower_bar_items[i].visible = true
			tower_bar_items[i].tower = available_towers_[i]
			
			var rect_: Rect2 = tower_bar_items[i].get_rect()
			
			tower_bar_items[i].position = Vector2(i * (rect_.size.x + (rect_.size.x / 8)), 0)
			
			if i == 0:
				_size.x += rect_.size.x
				_size.y = rect_.size.y
			else:
				_size.x += rect_.size.x + (rect_.size.x / 8)
		else:
			tower_bar_items[i].visible = false
	
	rect_changed.emit(self)

func get_rect() -> Rect2:
	return Rect2(Vector2.ZERO, _size)
