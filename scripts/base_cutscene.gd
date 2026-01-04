extends BaseNode2D
class_name BaseCutscene

@export var scenes: Array[CutsceneScene] = []

var alias: StringName
var is_cutscene_started: bool = false
var current_scene_index: int = 0
var current_scene_delta: float = 0.0

signal cutscene_stopped(cutscene_: BaseCutscene)

func _init(alias_: StringName) -> void:
	alias = alias_
	
func reset(reset_type_: Core.ResetType) -> void:
	super.reset(reset_type_)
	
	if (reset_type_ == Core.ResetType.START or
		reset_type_ == Core.ResetType.RESTART
	):
		is_cutscene_started = false
		current_scene_index = 0
		current_scene_delta = 0.0
	elif reset_type_ == Core.ResetType.STOP:
		stop_cutscene()

func start_cutscene() -> void:
	current_scene_index = 0
	current_scene_delta = 0.0
	
	if scenes.size() > 0:
		is_cutscene_started = true
		show_scene(0, scenes[0].name)

func stop_cutscene() -> void:
	if is_cutscene_started:
		is_cutscene_started = false
		cutscene_stopped.emit(self)
	
func next_scene() -> void:
	if current_scene_index == scenes.size() - 1:
		stop_cutscene()
		return
	
	current_scene_index += 1
	current_scene_delta = 0.0
	show_scene(current_scene_index, scenes[current_scene_index].name)
			
func show_scene(index_: int, name_: StringName) -> void:
	for i: int in %Scenes.get_children().size():
		if i == index_:
			%Scenes.get_child(i).visible = true
		else:
			%Scenes.get_child(i).visible = false

func _process(delta_: float) -> void:
	super._process(delta_)
	
	if not is_running():
		return
	
	if not is_cutscene_started:
		return

	if scenes[current_scene_index].time_seconds < 0:
		return

	if current_scene_delta > scenes[current_scene_index].time_seconds:
		next_scene()
	else:
		current_scene_delta += delta_
