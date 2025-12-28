extends BaseLevel
class_name TowerDefenceLevel

@export var settings: LevelSettings = LevelSettings.new()

var current_money: int = 0

var is_placing_tower: bool:
	get:
		return area.is_placing_tower
	set(value):
		area.is_placing_tower = value

func _init(alias_: StringName) -> void:
	super._init(alias_)
	
func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		current_money = settings.start_money
		Core.hud.get_hud(&"money").set_money(current_money)
		Core.hud.get_hud(&"tower_bar").refresh()
		
func add_money(amount_: int) -> void:
	current_money += amount_
	Core.hud.get_hud(&"money").set_money(current_money)
	
func get_command_tower_position() -> Vector2:
	if area == null:
		return Vector2.ZERO
		
	var tower: Node2D = area.get_node_or_null("%CommandTower")
	if tower == null:
		return Vector2.ZERO
		
	return tower.global_position

func get_available_towers() -> Array[StringName]:
	var towers_: Array[StringName] = []

	if settings.can_purchase_pippa:
		towers_.push_back(&"pippa")
	
	if settings.can_purchase_shiina:
		towers_.push_back(&"shiina")
	
	if settings.can_purchase_jelly:
		towers_.push_back(&"jelly")
	
	return towers_

func can_purchase_tower(alias_: StringName) -> bool:
	if not get_available_towers().has(alias_):
		return false
		
	if get_tower_price(alias_) > current_money:
		return false
	
	if is_placing_tower:
		return false
	
	return true
	
func get_tower_price(alias_: StringName) -> int:
	match alias_:
		&"pippa":
			return settings.pippa_price
		&"shiina":
			return settings.shiina_price
		&"jelly":
			return settings.jelly_price
			
	return 0
	
func purchase_tower(alias_: StringName) -> void:
	if not can_purchase_tower(alias_):
		return
		
	current_money -= get_tower_price(alias_)
	Core.hud.get_hud(&"money").set_money(current_money)
	
	area.place_tower(alias_)

func refund_tower(alias_: StringName) -> void:
	current_money += get_tower_price(alias_)
	Core.hud.get_hud(&"money").set_money(current_money)

func can_place_tower_at_coords(coords_: Vector2i) -> bool:
	return area.can_place_tower_at_coords(coords_)
