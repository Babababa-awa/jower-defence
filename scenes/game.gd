extends BaseGame
class_name Game

var day_night_cycle: DayNightCycle = null
var mouse_action: StringName = &""
var mouse_action_delay: float = 0.1
var mouse_action_delta: float = 0.0
var cutscenes: Node = null

signal tower_command_changed(tower_: TowerDefenceTowerUnit)

func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		mouse_action = &""

func _ready() -> void:
	day_night_cycle = %DayNightCycle
	day_night_cycle.pause_time = true
	cutscenes = %CutScenes
	for child_: Node in cutscenes.get_children():
		if child_ is BaseCutscene:
			child_.cutscene_stopped.connect(_on_cutscene_stopped)
			child_.start()

	super._ready()

func _on_cutscene_stopped(cutscene_: BaseCutscene) -> void:
	cutscene_.visible = false
	cutscenes.visible = false

func _process(delta_: float) -> void:
	super._process(delta_)

	if not is_enabled:
		return
	
	if mouse_action_delta < mouse_action_delay:
		mouse_action_delta += delta_

func _input(event_: InputEvent) -> void:
	super._input(event_)
	
	if Core.game.cutscenes.visible:
		return
	
	if not is_tower_command_visible():
		return
		
	if has_mouse_action():
		return
	
	if event_ is InputEventMouseButton and event_.pressed:
		if event_.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			hide_tower_command()

func _handle_pause() -> void:
	if cutscenes.visible:
		if Input.is_action_just_pressed(&"pause"):
			stop_cutscene()
		return

	super._handle_pause()

func get_cutscene(cutscene_: StringName) -> BaseCutscene:
	for child_: Node in cutscenes.get_children():
		if child_ is BaseCutscene and child_.alias == cutscene_:
			return child_
	
	return null
	
func start_cutscene(cutscene_: StringName) -> void:
	var found_: bool = false
	
	for child_: Node in cutscenes.get_children():
		if child_ is BaseCutscene:
			if child_.alias == cutscene_:
				child_.visible = true
				child_.start_cutscene()
				found_ = true
			else:
				child_.visible = false
				child_.stop_cutscene()
	
	cutscenes.visible = found_

func stop_cutscene() -> void:
	for child_: Node in cutscenes.get_children():
		if child_ is BaseCutscene:
			if child_.is_cutscene_started:
				child_.stop_cutscene()
	
	cutscenes.visible = false
func add_level_child(node: Node2D) -> void:
	if node is TowerDefenceEnemyUnit or node is Sakana:
		%Enemies.add_child(node)
	elif node is TowerDefenceTowerUnit:
		%Towers.add_child(node)
	elif node is TowerDefenceProjectileUnit:
		%Projectiles.add_child(node)
	else:
		super.add_level_child(node)

func remove_level_child(node: Node2D) -> void:
	if node is TowerDefenceEnemyUnit or node is Sakana:
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
