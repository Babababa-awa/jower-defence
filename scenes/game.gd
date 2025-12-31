extends BaseGame
class_name Game

var day_night_cycle: DayNightCycle = null
var mouse_action: StringName = &""
var mouse_action_delay: float = 0.1
var mouse_action_delta: float = 0.0

signal tower_command_changed(tower_: TowerDefenceTowerUnit)

func _ready() -> void:
	day_night_cycle = %DayNightCycle

	super._ready()
	
func _process(delta_: float) -> void:
	super._process(delta_)

	if not is_enabled:
		return
	
	if mouse_action_delta < mouse_action_delay:
		mouse_action_delta += delta_


func _input(event_: InputEvent) -> void:
	super._input(event_)
	
	if not is_tower_command_visible():
		return
		
	if has_mouse_action():
		return
	
	if event_ is InputEventMouseButton and event_.pressed:
		if event_.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			hide_tower_command()
			
			
func add_level_child(node: Node2D) -> void:
	if node is TowerDefenceEnemyUnit:
		%Enemies.add_child(node)
	elif node is TowerDefenceTowerUnit:
		%Towers.add_child(node)
	elif node is TowerDefenceProjectileUnit:
		%Projectiles.add_child(node)
	else:
		super.add_level_child(node)

func remove_level_child(node: Node2D) -> void:
	if node is TowerDefenceEnemyUnit:
		%Enemies.remove_child(node)
	elif node is TowerDefenceTowerUnit:
		%Towers.remove_child(node)
	elif node is TowerDefenceProjectileUnit:
		%Projectiles.remove_child(node)
	else:
		super.remove_level_child(node)
	
func get_command_tower() -> TowerDefenceCommandTowerUnit:
	if Core.level is TowerDefenceLevel:
		return Core.level.get_command_tower()
		
	return null

func set_mouse_action(mouse_action_: StringName) -> void:
	mouse_action = mouse_action_
	
func clear_mouse_action(mouse_action_: StringName, delay: bool = false) -> void:
	if mouse_action != mouse_action_:
		return
		
	mouse_action = &""
	
	if delay:
		mouse_action_delta = 0.0
	else:
		mouse_action_delta = mouse_action_delay

func has_mouse_action() -> bool:
	if mouse_action_delta < mouse_action_delay:
		return true
		
	return mouse_action != &""

func can_mouse_action(mouse_action_: StringName) -> bool:
	if mouse_action != &"":
		return false
		
	if (mouse_action_ == &"set_tower_target" or
		mouse_action_ == &"command_button_hover" or
		mouse_action_ == &"command_box_hover" or
		mouse_action_ == &"button_hover"
	):
		return true
		
	if mouse_action_delta < mouse_action_delay:
		return false
		
	return true
	
func hide_tower_command() -> void:
	if %TowerCommand.visible:
		%TowerCommand.hide()
		%TowerCommand.tower = null
		tower_command_changed.emit(null)

func show_tower_command(tower_: TowerDefenceTowerUnit) -> void:
	%TowerCommand.tower = tower_
	%TowerCommand.global_position = tower_.global_position - Vector2(0, 128)
	%TowerCommand.show()
	tower_command_changed.emit(tower_)

func is_tower_command_visible() -> bool:
	return %TowerCommand.visible
