extends BaseArea
class_name TowerDefenceArea

var is_placing_tower: bool = false
var active_tower: TowerDefenceTowerUnit = null
var tower_coords: Array[Vector2i] = []

func _ready() -> void:
	for child_: Node2D in get_children():
		if child_ is EnemySpawner:
			child_.connect(&"spawn", _on_spawn)

func _process(delta_: float) -> void:
	super._process(delta_)
	
func _input(event: InputEvent) -> void:
	if (is_placing_tower and
		event is InputEventMouseButton and 
		event.pressed
	):
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			var coords_: Vector2i = Vector2i(active_tower.position.round())
			if can_place_tower_at_coords(coords_):
				is_placing_tower = false
				%Place.visible = false
				active_tower.stop_place()
				active_tower.set_target()
				tower_coords.push_back(coords_)
				Core.game.clear_mouse_action(&"place_tower")
				active_tower.set_target()
				active_tower = null
		elif event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			is_placing_tower = false
			%Place.visible = false
			Core.level.refund_tower(active_tower.alias)
			active_tower.stop_place()
			Core.nodes.free_node(active_tower)
			active_tower = null
			Core.game.clear_mouse_action(&"place_tower", true)

func _on_spawn(spawner_: Node2D, unit_: Node2D) -> void:
	if unit_ is TowerDefenceEnemyUnit:
		unit_.set_path(_get_path(spawner_.paths))
	
func _get_path(paths_: Node2D) -> Path2D:
	if paths_ == null or paths_.get_child_count() == 0:
		return null
	
	var index_: int = randi_range(0, paths_.get_child_count() -1)
	return paths_.get_child(index_)

func place_tower(alias_: StringName) -> void:
	if not Core.game.can_mouse_action(&"place_tower"):
		return
	
	Core.game.hide_tower_command()
	Core.game.set_mouse_action(&"place_tower")
	
	is_placing_tower = true
	%Place.visible = true
	
	var tower_: TowerDefenceTowerUnit = await Core.nodes.get_node("res://scenes/unit/tower/" + alias_ + ".tscn")
	tower_.position = Vector2.ZERO
	tower_.start_place()
	active_tower = tower_

func can_place_tower_at_coords(coords_: Vector2i) -> bool:
	var tile_coords_: Vector2i = coords_ / Core.TILE_SIZE

	if %Place.get_cell_tile_data(tile_coords_) == null:
		return false
	
	tile_coords_.x -= 1
	if %Place.get_cell_tile_data(tile_coords_) == null:
		return false

	tile_coords_.y -= 1
	if %Place.get_cell_tile_data(tile_coords_) == null:
		return false
		
	tile_coords_.x += 1
	if %Place.get_cell_tile_data(tile_coords_) == null:
		return false
	
	# Jam code!
	if tower_coords.has(coords_):
		return false
		
	coords_.x += Core.TILE_SIZE
	if tower_coords.has(coords_):
		return false
		
	coords_.y -= Core.TILE_SIZE
	if tower_coords.has(coords_):
		return false
		
	coords_.x -= Core.TILE_SIZE
	if tower_coords.has(coords_):
		return false
	
	coords_.x -= Core.TILE_SIZE
	if tower_coords.has(coords_):
		return false
		
	coords_.y += Core.TILE_SIZE
	if tower_coords.has(coords_):
		return false
	
	coords_.y += Core.TILE_SIZE
	if tower_coords.has(coords_):
		return false
		
	coords_.x += Core.TILE_SIZE
	if tower_coords.has(coords_):
		return false
	
	coords_.x += Core.TILE_SIZE
	if tower_coords.has(coords_):
		return false
	
	return true
