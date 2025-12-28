@tool
extends Control

@onready var _header_labels: Array[Label] = [
	%LabelSetup,
	%LabelAudio,
	%LabelGame,
	%LabelLevels,
	%LabelHUD,
	%LabelUI,
	%LabelData,
	%LabelFileSystem,
	%LabelInput,
	%LabelSettings,
	%LabelLocalization,
	%LabelDebug,
	%LabelInitialize,
]

#@onready var _subheader_labels: Array[Label] = [
	#%LabelMouseSpeed,
	#%LabelJoypadSpeed,
#]

func _ready() -> void:
	var theme_: Theme = EditorInterface.get_editor_theme()
	
	for label_: Label in _header_labels:
		label_.add_theme_font_override("font", theme_.get_font("title", "EditorFonts"))
		label_.add_theme_font_size_override("font_size", theme_.get_font_size("title_size", "EditorFonts"))
		label_.add_theme_color_override("font_color", theme_.get_color("font_color", "Editor"))
		
	#for label_: Label in _subheader_labels:
		#label_.add_theme_font_override("font", theme_.get_font("bold", "EditorFonts"))

	%OptionButtonViewportSize.clear()
	%OptionButtonViewportSize.add_item("180 x 90")
	%OptionButtonViewportSize.add_item("320 x 180")
	%OptionButtonViewportSize.add_item("640 x 360")
	%OptionButtonViewportSize.add_item("1920 x 1080")
	#%OptionButtonViewportSize.add_item("2560 x 1440")
	#%OptionButtonViewportSize.add_item("3840 x 2160")
	%OptionButtonViewportSize.select(1)
	
	%OptionButtonTileSize.clear()
	%OptionButtonTileSize.add_item("4 px")
	%OptionButtonTileSize.add_item("8 px")
	%OptionButtonTileSize.add_item("16 px")
	%OptionButtonTileSize.add_item("32 px")
	%OptionButtonTileSize.add_item("64 px")
	%OptionButtonTileSize.add_item("128 px")
	%OptionButtonTileSize.add_item("256 px")
	%OptionButtonTileSize.add_item("512 px")
	%OptionButtonTileSize.select(1)
	
	%OptionButtonPhysicsSize.clear()
	%OptionButtonPhysicsSize.add_item("4 px")
	%OptionButtonPhysicsSize.add_item("8 px")
	%OptionButtonPhysicsSize.add_item("16 px")
	%OptionButtonPhysicsSize.add_item("32 px")
	%OptionButtonPhysicsSize.add_item("64 px")
	%OptionButtonPhysicsSize.add_item("128 px")
	%OptionButtonPhysicsSize.add_item("256 px")
	%OptionButtonPhysicsSize.add_item("512 px")
	%OptionButtonPhysicsSize.select(1)
	
	%OptionButtonFieldSize.clear()
	%OptionButtonFieldSize.add_item("4 px")
	%OptionButtonFieldSize.add_item("8 px")
	%OptionButtonFieldSize.add_item("16 px")
	%OptionButtonFieldSize.add_item("32 px")
	%OptionButtonFieldSize.add_item("64 px")
	%OptionButtonFieldSize.add_item("128 px")
	%OptionButtonFieldSize.add_item("256 px")
	%OptionButtonFieldSize.add_item("512 px")
	%OptionButtonFieldSize.select(1)
	
	%OptionButtonCursorSize.clear()
	%OptionButtonCursorSize.add_item("4 px")
	%OptionButtonCursorSize.add_item("8 px")
	%OptionButtonCursorSize.add_item("16 px")
	%OptionButtonCursorSize.add_item("32 px")
	%OptionButtonCursorSize.add_item("64 px")
	%OptionButtonCursorSize.add_item("128 px")
	%OptionButtonCursorSize.add_item("256 px")
	%OptionButtonCursorSize.add_item("512 px")
	%OptionButtonCursorSize.select(1)

func _on_button_create_core_global_pressed() -> void:
	_create_core_global()
	
	EditorInterface.restart_editor(true)

func _on_button_initialize_pressed() -> void:
	_create_folders()
	
	_update_project_settings()
	
	await _setup_localization()
	
	_create_audio_bus_layout()
#
	await _create_physics_tile_set()
	
	await _create_single_tile_set("win", 14)
	
	await _create_single_tile_set("lose", 15, {"type": TYPE_INT})
	
	_create_field_tile_set()
	
	await _create_ui()
	
	_create_settings_data()
	
	_create_sfx_data()
	
	_create_credits_data()
	
	_create_level_select_data()
	
	_create_controls_data()
	
	_create_input_data()
	
	_set_folder_colors()
	
	_create_main_scene()
	
	_create_menu_level()
	
	_create_start_level()
	
	ProjectSettings.save()
	
	EditorInterface.get_resource_filesystem().scan_sources()
	
func _update_project_settings() -> void:
	if %CheckBoxStrictTyping.button_pressed:
		ProjectSettings.set_setting("debug/gdscript/warnings/untyped_declaration", 2)
		ProjectSettings.set_setting("debug/gdscript/warnings/inferred_declaration", 2)
		
	var viewport_size_: PackedStringArray = %OptionButtonViewportSize.get_item_text(%OptionButtonViewportSize.selected).split(" x ")
	var viewport_width_: int = int(viewport_size_[0])
	var viewport_height_: int = int(viewport_size_[1])
	
	ProjectSettings.set_setting("display/window/size/viewport_width", viewport_width_)
	ProjectSettings.set_setting("display/window/size/viewport_height", viewport_height_)
	ProjectSettings.set_setting("display/window/size/mode", DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	
	if viewport_width_ >= 1920:
		ProjectSettings.set_setting("display/window/stretch/mode", "canvas_items")
		ProjectSettings.set_setting("display/window/stretch/aspect", "keep_height")
		ProjectSettings.set_setting("display/window/stretch/scale_mode", "fractional")
		
		ProjectSettings.set_setting("rendering/textures/canvas_textures/default_texture_filter", 1)
	else:
		ProjectSettings.set_setting("display/window/stretch/mode", "viewport")
		ProjectSettings.set_setting("display/window/stretch/aspect", "keep_height")
		ProjectSettings.set_setting("display/window/stretch/scale_mode", "integer")
		
		ProjectSettings.set_setting("rendering/textures/canvas_textures/default_texture_filter", 0)
	
	if %CheckBoxLayerNames.button_pressed:
		ProjectSettings.set_setting("layer_names/2d_physics/layer_1", "Solid")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_2", "Liquid")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_3", "Gas")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_4", "Floor")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_5", "Wall")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_6", "Ceiling")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_7", "Roam")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_8", "Climb")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_9", "Stairs")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_10", "Edge")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_11", "Elevation")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_12", "Rise")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_13", "Fall")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_14", "Rail")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_15", "Win")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_16", "Lose")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_17", "Modifier")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_18", "Status")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_19", "Interaction")
		ProjectSettings.set_setting("layer_names/2d_physics/layer_20", "Field")

func _create_folders() -> void:
	if not %CheckBoxFolders.button_pressed:
		return
	
	DirAccess.make_dir_recursive_absolute("res://_")
	DirAccess.make_dir_recursive_absolute("res://assets")
	DirAccess.make_dir_recursive_absolute("res://data")
	DirAccess.make_dir_recursive_absolute("res://resources")
	DirAccess.make_dir_recursive_absolute("res://scenes")
	DirAccess.make_dir_recursive_absolute("res://scripts")

func _set_folder_colors() -> void:
	if not %CheckBoxFolderColors.button_pressed:
		return
		
	var folder_colors: Dictionary = {}
	
	if DirAccess.dir_exists_absolute("res://_/"):
		folder_colors.set("res://_/", "teal")
	
	if DirAccess.dir_exists_absolute("res://addons/"):
		folder_colors.set("res://addons/", "purple")
	
	if DirAccess.dir_exists_absolute("res://addons/retrograde/_/"):
		folder_colors.set("res://addons/retrograde/_/", "teal")
	
	if DirAccess.dir_exists_absolute("res://addons/retrograde/data/"):
		folder_colors.set("res://addons/retrograde/data/", "blue")
	
	if DirAccess.dir_exists_absolute("res://addons/retrograde/scenes/"):
		folder_colors.set("res://addons/retrograde/scenes/", "green")
		
	if DirAccess.dir_exists_absolute("res://addons/retrograde/scripts/"):
		folder_colors.set("res://addons/retrograde/scripts/", "yellow")
		
	if DirAccess.dir_exists_absolute("res://addons/"):
		folder_colors.set("res://addons/", "purple")
		
	if DirAccess.dir_exists_absolute("res://assets/"):
		folder_colors.set("res://assets/", "orange")
	
	if DirAccess.dir_exists_absolute("res://data/"):
		folder_colors.set("res://data/", "blue")
	
	if DirAccess.dir_exists_absolute("res://resources/"):
		folder_colors.set("res://resources/", "red")
	
	if DirAccess.dir_exists_absolute("res://scenes/"):
		folder_colors.set("res://scenes/", "green")
		
	if DirAccess.dir_exists_absolute("res://scripts/"):
		folder_colors.set("res://scripts/", "yellow")
	
	ProjectSettings.set_setting("file_customization/folder_colors", folder_colors)

func _create_core_global() -> void:
	if not %CheckBoxCoreGlobal.button_pressed:
		return
		
	var path_: String = "res://scripts/core.gd"
	
	if FileAccess.file_exists(path_) and not %CheckBoxOverride.button_pressed:
		return
	
	var error_: Error = DirAccess.make_dir_recursive_absolute("res://scripts")
	if error_ != OK:
		return
	
	var tile_size_: int = int(%OptionButtonTileSize.get_item_text(%OptionButtonTileSize.selected).split(" ")[0])
	var physics_size_: int = int(%OptionButtonPhysicsSize.get_item_text(%OptionButtonPhysicsSize.selected).split(" ")[0])
	var field_size_: int = int(%OptionButtonFieldSize.get_item_text(%OptionButtonFieldSize.selected).split(" ")[0])
	var cursor_size_: int = int(%OptionButtonFieldSize.get_item_text(%OptionButtonFieldSize.selected).split(" ")[0])
	
	var script_: String = "";
	
	var translations_: PackedStringArray = []
	
	if %CheckBoxEnglish.button_pressed:
		translations_.push_back("en")
		
	if %CheckBoxJapanese.button_pressed:
		translations_.push_back("jp")
		
	if translations_.size() != 2:
		script_ += "\tLOCALES = [\"" + "\", \"".join(translations_) + "\"]\n"
	
	if %CheckBoxStartLevel.button_pressed:
		if %CheckBoxMenuStart.button_pressed:
			script_ += "\tMENU_LEVEL = &\"" + %LineEditStartLevelAlais.text + "\"\n"
			
		if %LineEditStartLevelAlais.text != "start":
			script_ += "\tSTART_LEVEL = &\"" + %LineEditStartLevelAlais.text + "\"\n"
	
	if tile_size_ != 8:
		script_ += "\tTILE_SIZE = " + str(tile_size_) + "\n"
	
	if physics_size_ != 8:
		script_ += "\tPHYSICS_TILE_SIZE = " + str(physics_size_) + "\n"
	
	if field_size_ != 8:
		script_ += "\tFIELD_TILE_SIZE = " + str(field_size_) + "\n"
	
	if %CheckBoxMouseCapture.button_pressed:
		script_ += "\tENABLE_MOUSE_CAPTURE = true\n"
	
	if cursor_size_ != 8:
		script_ += "\tMOUSE_CURSOR_SIZE = " + str(cursor_size_) + "\n"
		
	if %CheckBoxUIGameDifficulty.button_pressed:
		script_ += "\tENABLE_GAME_DIFFICULTY = true\n"
	
	if %CheckBoxUILevelSelect.button_pressed:
		script_ += "\tENABLE_LEVEL_SELECT = true\n"
		
		if %CheckBoxUILevelSkip.button_pressed:
			script_ += "\tENABLE_LEVEL_SKIP = true\n"
		
		if %CheckBoxUILevelPrevious.button_pressed:
			script_ += "\tENABLE_LEVEL_PREVIOUS = true\n"
			
		if %CheckBoxUILevelNext.button_pressed:
			script_ += "\tENABLE_LEVEL_NEXT = true\n"
	
	if %CheckBoxUIPlayAgain.button_pressed:
		script_ += "\tENABLE_PLAY_AGAIN = true\n"
	
	if script_ == "":
		script_ = "extends Retrograde\n"
	else:
		script_ = "extends Retrograde\n\nfunc _init() -> void:\n" + script_
	
	var file_: FileAccess = FileAccess.open(path_, FileAccess.WRITE)
	file_.store_string(script_)
	file_.close()
	
	ProjectSettings.set_setting("autoload/Core", "*" + path_)
	ProjectSettings.save()

func _create_audio_bus_layout() -> void:
	if not %CheckBoxAudioBusLayout.button_pressed:
		return

	var path_: String = "res://resources/audio_bus_layout.tres"
	
	if FileAccess.file_exists(path_) and not %CheckBoxOverride.button_pressed:
		return
		
	# Manually create Audio Bus Layout file
	var uid: int = ResourceUID.create_id()
	var text_uid: String = ResourceUID.id_to_text(uid)
	var bus_index_: int = 1
	
	var resource_text_: String = "[gd_resource type=\"AudioBusLayout\" format=3 uid=\"" + text_uid + "\"]\n\n[resource]\n"
	
	if %CheckBoxMusic.button_pressed:
		resource_text_ += "bus/" + str(bus_index_) + "/name = &\"Music\"\n"
		resource_text_ += "bus/" + str(bus_index_) + "/solo = false\n"
		resource_text_ += "bus/" + str(bus_index_) + "/mute = false\n"
		resource_text_ += "bus/" + str(bus_index_) + "/bypass_fx = false\n"
		resource_text_ += "bus/" + str(bus_index_) + "/volume_db = 0.0\n"
		resource_text_ += "bus/" + str(bus_index_) + "/send = &\"Master\"\n"
		bus_index_ += 1
	
	if %CheckBoxAmbiance.button_pressed:
		resource_text_ += "bus/" + str(bus_index_) + "/name = &\"Ambiance\"\n"
		resource_text_ += "bus/" + str(bus_index_) + "/solo = false\n"
		resource_text_ += "bus/" + str(bus_index_) + "/mute = false\n"
		resource_text_ += "bus/" + str(bus_index_) + "/bypass_fx = false\n"
		resource_text_ += "bus/" + str(bus_index_) + "/volume_db = 0.0\n"
		resource_text_ += "bus/" + str(bus_index_) + "/send = &\"Master\"\n"
		bus_index_ += 1
		
	if %CheckBoxSFX.button_pressed:
		resource_text_ += "bus/" + str(bus_index_) + "/name = &\"SFX\"\n"
		resource_text_ += "bus/" + str(bus_index_) + "/solo = false\n"
		resource_text_ += "bus/" + str(bus_index_) + "/mute = false\n"
		resource_text_ += "bus/" + str(bus_index_) + "/bypass_fx = false\n"
		resource_text_ += "bus/" + str(bus_index_) + "/volume_db = 0.0\n"
		resource_text_ += "bus/" + str(bus_index_) + "/send = &\"Master\"\n"

	var file_: FileAccess = FileAccess.open(path_, FileAccess.WRITE)
	file_.store_string(resource_text_)
	file_.close()
	
	ProjectSettings.set_setting("audio/buses/default_bus_layout", path_)

func _create_main_scene() -> void:
	if not %CheckBoxMainScene.button_pressed:
		return
		
	var script_path_: String = "res://scenes/game.gd"
	var scene_path_: String = "res://scenes/game.tscn"
	
	if FileAccess.file_exists(scene_path_) and not %CheckBoxOverride.button_pressed:
		return
	
	if not FileAccess.file_exists(script_path_) or %CheckBoxOverride.button_pressed:
		var script_: GDScript = GDScript.new()
		script_.source_code = "extends BaseGame\nclass_name Game\n"
		
		if %CheckBoxLevelController.button_pressed and %CheckBoxDayNightCycle.button_pressed:
			script_.source_code += "\nvar day_night_cycle: DayNightCycle = null\n\n"
			script_.source_code += "func _ready() -> void:\n"
			script_.source_code += "\tday_night_cycle = %DayNightCycle\n\n"
			script_.source_code += "\tsuper._ready()"
		
		ResourceSaver.save(script_, script_path_)
	
	var root_: Node = Node.new()
	root_.name = &"Game"
	root_.set_script(load(script_path_))
	
	if %CheckBoxAmbianceController.button_pressed:
		var ambiance_: Node2D = Node2D.new()
		ambiance_.name = &"Ambiance"
		ambiance_.unique_name_in_owner = true
		root_.add_child(ambiance_)
		ambiance_.owner = root_
		
	if %CheckBoxLevelController.button_pressed:
		var level_: Node2D = Node2D.new()
		level_.name = &"Level"
		level_.unique_name_in_owner = true
		root_.add_child(level_)
		level_.owner = root_
		
		if %CheckBoxCamera.button_pressed:
			var camera_: Camera2D = TargetCamera2D.new()
			camera_.name = &"Camera"
			camera_.unique_name_in_owner = true
			camera_.limit_smoothed = true
			camera_.position_smoothing_enabled = true
			level_.add_child(camera_)
			camera_.owner = root_
			
		if %CheckBoxPlayerGrid.button_pressed:
			var player_grid_: PlayerGrid = PlayerGrid.new()
			player_grid_.name = &"PlayerGrid"
			player_grid_.unique_name_in_owner = true
			level_.add_child(player_grid_)
			player_grid_.owner = root_
			
		if %CheckBoxDayNightCycle.button_pressed:
			var day_night_cycle_: DayNightCycle = DayNightCycle.new()
			day_night_cycle_.name = &"DayNightCycle"
			day_night_cycle_.unique_name_in_owner = true
			level_.add_child(day_night_cycle_)
			day_night_cycle_.owner = root_
			
	if %CheckBoxHUDController.button_pressed:
		var hud_: HUDController = HUDController.new()
		hud_.name = &"HUD"
		hud_.unique_name_in_owner = true
		root_.add_child(hud_)
		hud_.owner = root_
		
	if %CheckBoxUIController.button_pressed:
		var ui_: UIController = UIController.new()
		ui_.name = &"UI"
		ui_.unique_name_in_owner = true
		root_.add_child(ui_)
		ui_.owner = root_
	
	var scene_: PackedScene = PackedScene.new()
	scene_.pack(root_)
	ResourceSaver.save(scene_, scene_path_)
	
	ProjectSettings.set_setting("application/run/main_scene", scene_path_)

func _create_menu_level() -> void:
	if not %CheckBoxMenuLevel.button_pressed or %CheckBoxMenuStart.button_pressed:
		return
	
	_create_level("menu")
	
func _create_start_level() -> void:
	if not %CheckBoxStartLevel.button_pressed:
		return
	
	_create_level(%LineEditStartLevelAlais.text)

func _create_level(alias_: String) -> void:
	var error_: Error = DirAccess.make_dir_recursive_absolute("res://scenes/level/" + alias_ + "/area")
	if error_ != OK:
		return
		
	error_ = DirAccess.make_dir_recursive_absolute("res://data/level/" + alias_ + "/area")
	if error_ != OK:
		return
		
	var script_path_: String = "res://scenes/level/" + alias_ + ".gd"
	var scene_path_: String = "res://scenes/level/" + alias_ + ".tscn"
	var area_script_path_: String = "res://scenes/level/" + alias_ + "/area/area_1.gd"
	var area_scene_path_: String = "res://scenes/level/" + alias_ + "/area/area_1.tscn"
	var level_data_path_: String = "res://data/level/" + alias_ + "/level.json"
	var level_area_data_path_: String = "res://data/level/" + alias_ + "/area/area_1.json"

	if FileAccess.file_exists(scene_path_) and not %CheckBoxOverride.button_pressed:
		return

	if not FileAccess.file_exists(script_path_) or %CheckBoxOverride.button_pressed:
		var script_: GDScript = GDScript.new()
		script_.source_code = "extends BaseLevel\n\nfunc _init() -> void:\n\tsuper._init(&\"" + alias_ + "\")"
		
		ResourceSaver.save(script_, script_path_)
		
	var root_: Node2D = Node2D.new()
	root_.name = StringName(alias_.to_pascal_case())
	root_.set_script(load(script_path_))
	
	var scene_: PackedScene = PackedScene.new()
	scene_.pack(root_)
	ResourceSaver.save(scene_, scene_path_)
	
	
	if not FileAccess.file_exists(area_scene_path_) or %CheckBoxOverride.button_pressed:
		if not FileAccess.file_exists(area_script_path_) or %CheckBoxOverride.button_pressed:
			var script_: GDScript = GDScript.new()
			script_.source_code = "extends BaseArea\n\nfunc _init() -> void:\n\tsuper._init(&\"area_1\")"
			
			ResourceSaver.save(script_, area_script_path_)
			
		var area_root_: Node2D = Node2D.new()
		area_root_.name = &"Area1"
		area_root_.set_script(load(area_script_path_))
		
		var area_scene_: PackedScene = PackedScene.new()
		area_scene_.pack(area_root_)
		ResourceSaver.save(area_scene_, area_scene_path_)
	
	if not FileAccess.file_exists(level_data_path_) or %CheckBoxOverride.button_pressed:
		var data_: Dictionary = {
			"alias": alias_,
			"name": alias_.capitalize(),
			"type": "platformer",
			"area": {
				"alias": "area_1"
			}
		}
		
		if alias_ != "menu":
			data_.set("player", {
				"alias": "player",
				"position": [0, 0],
				"mode": "normal",
			})
		
		var json_: String = JSON.stringify(data_, "\t", false)
		
		var file_: FileAccess = FileAccess.open(level_data_path_, FileAccess.WRITE)
		file_.store_string(json_)
		file_.close()
	
	if not FileAccess.file_exists(level_area_data_path_) or %CheckBoxOverride.button_pressed:
		var data_: Dictionary = {
			"alias": "area_1",
			"Name": "Area 1",
			"music": null,
			"ambiance": null
		}
		
		var json_: String = JSON.stringify(data_, "\t", false)
		
		var file_: FileAccess = FileAccess.open(level_area_data_path_, FileAccess.WRITE)
		file_.store_string(json_)
		file_.close()

func _create_physics_tile_set() -> void:
	var path_: String = "res://resources/tile_sets/physics.tres"
	
	if FileAccess.file_exists(path_) and not %CheckBoxOverride.button_pressed:
		return
		
	DirAccess.make_dir_recursive_absolute("res://assets/tile_sets/physics")
	DirAccess.make_dir_recursive_absolute("res://resources/tile_sets")
	
	var size_: String = %OptionButtonPhysicsSize.get_item_text(%OptionButtonPhysicsSize.selected).split(" ")[0]
	
	DirAccess.copy_absolute(
		"res://addons/retrograde/_/assets/tile_sets/physics/structure_" + size_ + ".png", 
		"res://assets/tile_sets/physics/structure.png"
	)
	DirAccess.copy_absolute(
		"res://addons/retrograde/_/assets/tile_sets/physics/climb_" + size_ + ".png", 
		"res://assets/tile_sets/physics/climb.png"
	)
	DirAccess.copy_absolute(
		"res://addons/retrograde/_/assets/tile_sets/physics/elevation_" + size_ + ".png", 
		"res://assets/tile_sets/physics/elevation.png"
	)
	
	EditorInterface.get_resource_filesystem().scan()
	
	while EditorInterface.get_resource_filesystem().is_scanning():
		await get_tree().process_frame
		
	while not ResourceLoader.exists("res://assets/tile_sets/physics/elevation.png"):
		await get_tree().process_frame

	var tile_set_: TileSet = TileSet.new()
	
	tile_set_.set_tile_size(Vector2i(int(size_), int(size_))) 
	
	for i_: int in range(0, 14):
		tile_set_.add_physics_layer(i_)
		tile_set_.set_physics_layer_collision_layer(i_, 1 << i_)
		tile_set_.set_physics_layer_collision_mask(i_, 0)
		
	_add_tile_set_atlas(tile_set_, "/physics", "structure", int(size_))
	_add_tile_set_atlas(tile_set_, "/physics", "climb", int(size_))
	_add_tile_set_atlas(tile_set_, "/physics", "elevation", int(size_))
	
	ResourceSaver.save(tile_set_, path_)

func _create_single_tile_set(name_: String, layer_: int, data_layers_: Dictionary = {}) -> void:
	var path_: String = "res://resources/tile_sets/" + name_ + ".tres"
	
	if FileAccess.file_exists(path_) and not %CheckBoxOverride.button_pressed:
		return
		
	DirAccess.make_dir_recursive_absolute("res://assets/tile_sets")
	DirAccess.make_dir_recursive_absolute("res://resources/tile_sets")
	
	var size_: String = %OptionButtonPhysicsSize.get_item_text(%OptionButtonPhysicsSize.selected).split(" ")[0]
	
	DirAccess.copy_absolute(
		"res://addons/retrograde/_/assets/tile_sets/" + name_ + "/" + name_ + "_" + size_ + ".png", 
		"res://assets/tile_sets/" + name_ + ".png"
	)

	EditorInterface.get_resource_filesystem().scan()
	
	while EditorInterface.get_resource_filesystem().is_scanning():
		await get_tree().process_frame
		
	# Wait for the physics images to be imported
	while not ResourceLoader.exists("res://assets/tile_sets/" + name_ + ".png"):
		await get_tree().process_frame

	var tile_set_: TileSet = TileSet.new()
	
	tile_set_.set_tile_size(Vector2i(int(size_), int(size_))) 
	
	tile_set_.add_physics_layer(0)
	tile_set_.set_physics_layer_collision_layer(0, 1 << layer_)
	tile_set_.set_physics_layer_collision_mask(0, 0)
	
	if not data_layers_.is_empty():
		for key_: String in data_layers_.keys():
			tile_set_.add_custom_data_layer()
			var layer_index_: int = tile_set_.get_custom_data_layers_count() - 1
			tile_set_.set_custom_data_layer_name(layer_index_, key_)
			tile_set_.set_custom_data_layer_type(layer_index_, data_layers_[key_])
		
	_add_tile_set_atlas(tile_set_, "", name_, int(size_))
	
	ResourceSaver.save(tile_set_, path_)
	
func _create_field_tile_set() -> void:
	pass

func _add_tile_set_atlas(
	tile_set_: TileSet,
	path_: String,
	name_: String, 
	size_: int
) -> void:
	var atlas_: TileSetAtlasSource = TileSetAtlasSource.new()
	atlas_.texture = load("res://assets/tile_sets" + path_ + "/" + name_ + ".png")
	atlas_.texture_region_size = Vector2i(size_, size_)
	tile_set_.add_source(atlas_)
	
	var data_: Dictionary = _load_json("res://addons/retrograde/_/data/tile_sets" + path_ + "/" + name_ + ".json")
	
	# Since some types can share the same physics layer, track which has already 
	# been set so as to not overwrite (JSON file should be set up in such a way 
	# that only one polygon per tile per physics layer.)
	var track_layers_: Dictionary = {}
	
	for type_: StringName in data_.keys():
		var layer_: int = _get_physics_layer_from_type(type_)
		if layer_ == -1:
			continue

		for tile_: Variant in data_.get(type_):
			if tile_ is String: # Skip comments
				continue
				
			var coords_: Vector2i = Vector2i(tile_.position[0], tile_.position[1])
			
			if not track_layers_.has(coords_):
				track_layers_[coords_] = []
			
			if not atlas_.has_tile(coords_):
				atlas_.create_tile(coords_)
			
			var tile_data_: TileData = atlas_.get_tile_data(coords_, 0)
			
			if track_layers_[coords_].has(layer_):
				continue
				
			track_layers_[coords_].push_back(layer_)
			
			tile_data_.add_collision_polygon(layer_)
			tile_data_.set_collision_polygon_points(layer_, 0, _get_polygon_from_points(tile_.points, size_))
			
			if tile_.get("one_way", false):
				tile_data_.set_collision_polygon_one_way(layer_, 0, true)
				
			if tile_.has("data"):
				for key_: String in tile_.data:
					tile_data_.set_custom_data(key_, tile_.data[key_])

func _get_polygon_from_points(points_: Array, size_: int) -> PackedVector2Array:
	var polygon_: PackedVector2Array = []
	
	for point_: Array in points_:
		polygon_.push_back(Vector2(point_[0], point_[1]) * roundi(float(size_) / 2))
	
	return polygon_

func _get_physics_layer_from_type(type_: String) -> int:
	match type_:
		"solid":
			return 0
		"liquid":
			return 1
		"gas":
			return 2
		"floor":
			return 3
		"wall":
			return 4
		"ceiling":
			return 5
		"roam":
			return 6
		"climb":
			return 7
		"stairs":
			return 8
		"edge":
			return 9
		"elevation":
			return 10
		"rise":
			return 11
		"fall":
			return 12
		"rail":
			return 13
		"win":
			return 0
		"lose":
			return 0
		"modifier":
			return 0
		"status":
			return 0
		"interaction":
			return 0
		"field":
			return 0
			
	return -1

func _create_ui() -> void:
	var size_: String = %OptionButtonViewportSize.get_item_text(%OptionButtonViewportSize.selected).split(" ")[0]
	
	var error_: Error = DirAccess.make_dir_recursive_absolute("res://assets/ui")
	if error_ != OK:
		return

	if DirAccess.dir_exists_absolute("res://addons/retrograde/_/assets/ui/" + size_):
		error_ = _copy_directory(
			"res://addons/retrograde/_/assets/ui/" + size_,
			"res://assets/ui",
			%CheckBoxOverride.button_pressed
		)
		if error_ != OK:
			return

	if not FileAccess.file_exists("res://resources/ui.tres") or %CheckBoxOverride.button_pressed:
		error_ = DirAccess.make_dir_recursive_absolute("res://resources")
		if error_ != OK:
			return
		
		EditorInterface.get_resource_filesystem().scan()
		
		while EditorInterface.get_resource_filesystem().is_scanning():
			await get_tree().process_frame
			
		while not ResourceLoader.exists("res://assets/ui/vscroll_bar/vscroll_bar_scroll_focus.png"):
			await get_tree().process_frame
			
		var theme_: Theme = load("res://addons/retrograde/_/resources/ui/ui_" + size_ + ".tres").duplicate(true)
		
		theme_.set_icon(
			"checked", 
			"CheckBox", 
			ResourceLoader.load("res://assets/ui/check_box/checked.png")
		)
		theme_.set_icon(
			"unchecked", 
			"CheckBox", 
			ResourceLoader.load("res://assets/ui/check_box/unchecked.png")
		)
		theme_.set_icon(
			"grabber", 
			"HSlider", 
			ResourceLoader.load("res://assets/ui/hslider/hslider_grabber.png")
		)
		theme_.set_icon(
			"grabber_highlight", 
			"HSlider", 
			ResourceLoader.load("res://assets/ui/hslider/hslider_grabber_highlight.png")
		)
		theme_.get_stylebox(
			"grabber_area", 
			"HSlider"
		).texture = ResourceLoader.load("res://assets/ui/hslider/hslider_grabber_area.png")
		theme_.get_stylebox(
			"grabber_area_highlight", 
			"HSlider"
		).texture = ResourceLoader.load("res://assets/ui/hslider/hslider_grabber_area_highlight.png")
		theme_.get_stylebox(
			"slider",
			"HSlider"
		).texture = ResourceLoader.load("res://assets/ui/hslider/hslider_slider.png")
		theme_.get_stylebox(
			"grabber",
			"VScrollBar"
		).texture = ResourceLoader.load("res://assets/ui/vscroll_bar/vscroll_bar_grabber.png")
		theme_.get_stylebox(
			"grabber_highlight",
			"VScrollBar"
		).texture = ResourceLoader.load("res://assets/ui/vscroll_bar/vscroll_bar_grabber_highlight.png")
		theme_.get_stylebox(
			"grabber_pressed",
			"VScrollBar"
		).texture = ResourceLoader.load("res://assets/ui/vscroll_bar/vscroll_bar_grabber_pressed.png")
		theme_.get_stylebox(
			"scroll",
			"VScrollBar"
		).texture = ResourceLoader.load("res://assets/ui/vscroll_bar/vscroll_bar_scroll.png")
		theme_.get_stylebox(
			"scroll_focus",
			"VScrollBar"
		).texture = ResourceLoader.load("res://assets/ui/vscroll_bar/vscroll_bar_scroll_focus.png")
			
		ResourceSaver.save(theme_, "res://resources/ui.tres")
		
		ProjectSettings.set_setting("gui/theme/custom", "res://resources/ui.tres")
	
	if not %CheckBoxUIData.button_pressed:
		return
	
	if not FileAccess.file_exists("res://data/ui.json") or %CheckBoxOverride.button_pressed:
		var data_: Dictionary = _load_json("res://addons/retrograde/_/data/ui.json")
		
		data_.enabled_ = []
		
		if %CheckBoxUIControls.button_pressed:
			data_.enabled_.push_back("controls")
			
		if %CheckBoxUICredits.button_pressed:
			data_.enabled_.push_back("credits")
			
		if %CheckBoxUIGameDifficulty.button_pressed:
			data_.enabled_.push_back("difficulty")
			
		data_.enabled_.push_back("loading")
		
		if %CheckBoxUILose.button_pressed:
			data_.enabled_.push_back("lose")
		
		data_.enabled_.push_back("menu")
		data_.enabled_.push_back("pause")
		data_.enabled_.push_back("settings")
		
		if %CheckBoxUIWin.button_pressed:
			data_.enabled_.push_back("win")
		
		var json_: String = JSON.stringify(data_, "\t", false)
		
		var file_: FileAccess = FileAccess.open("res://data/ui.json", FileAccess.WRITE)
		file_.store_string(json_)
		file_.close()

func _create_settings_data() -> void:
	if not %CheckBoxSettingsData.button_pressed:
		return
	
	if FileAccess.file_exists("res://data/ui/settings.json") and not %CheckBoxOverride.button_pressed:
		return
		
	var error_: Error = DirAccess.make_dir_recursive_absolute("res://data/ui")
	if error_ != OK:
		return
	
	var data_: Dictionary = _load_json("res://addons/retrograde/_/data/ui/settings.json")
	data_.enabled = []

	if %CheckBoxAudio.button_pressed:
		data_.enabled.push_back("audio_master")
		
		if %CheckBoxMusic.button_pressed:
			data_.enabled.push_back("audio_music")
			
		if %CheckBoxSFX.button_pressed:
			data_.enabled.push_back("audio_music")
			
		if %CheckBoxAmbiance.button_pressed:
			data_.enabled.push_back("audio_music")
	
	if %CheckBoxNormalMouseSpeed.button_pressed:
		data_.enabled.push_back("normal_mouse_speed")
		
	if %CheckBoxSlowMouseSpeed.button_pressed:
		data_.enabled.push_back("slow_mouse_speed")
		
	if %CheckBoxFastMouseSpeed.button_pressed:
		data_.enabled.push_back("fast_mouse_speed")
		
	if %CheckBoxNormalJoypadSpeed.button_pressed:
		data_.enabled.push_back("normal_joypad_speed")
		
	if %CheckBoxSlowJoypadSpeed.button_pressed:
		data_.enabled.push_back("slow_joypad_speed")
		
	if %CheckBoxFastJoypadSpeed.button_pressed:
		data_.enabled.push_back("fast_joypad_speed")
		
	if %CheckBoxJoypadVibrations.button_pressed:
		data_.enabled.push_back("joypad_vibrations")
	
	var json_: String = JSON.stringify(data_, "\t", false)
	
	var file_: FileAccess = FileAccess.open("res://data/ui/settings.json", FileAccess.WRITE)
	file_.store_string(json_)
	file_.close()
	
func _create_sfx_data() -> void:
	if not %CheckBoxSFXData.button_pressed:
		return
	
	if FileAccess.file_exists("res://data/audio/sfx.json") and not %CheckBoxOverride.button_pressed:
		return
		
	var error_: Error = DirAccess.make_dir_recursive_absolute("res://data/audio")
	if error_ != OK:
		return
		
	DirAccess.copy_absolute(
		"res://addons/retrograde/_/data/audio/sfx.json", 
		"res://data/audio/sfx.json"
	)

func _create_credits_data() -> void:
	if not %CheckBoxCreditsData.button_pressed:
		return
	
	if FileAccess.file_exists("res://data/ui/credits.json") and not %CheckBoxOverride.button_pressed:
		return
		
	var error_: Error = DirAccess.make_dir_recursive_absolute("res://data/ui")
	if error_ != OK:
		return
		
	DirAccess.copy_absolute(
		"res://addons/retrograde/_/data/ui/credits.json", 
		"res://data/ui/credits.json"
	)
	
func _create_level_select_data() -> void:
	if not %CheckBoxLevelSelectData.button_pressed:
		return
	
	if FileAccess.file_exists("res://data/ui/level_select.json") and not %CheckBoxOverride.button_pressed:
		return
		
	var error_: Error = DirAccess.make_dir_recursive_absolute("res://data/ui")
	if error_ != OK:
		return
		
	DirAccess.copy_absolute(
		"res://addons/retrograde/_/data/ui/level_select.json", 
		"res://data/ui/level_select.json"
	)

func _create_controls_data() -> void:
	if not %CheckBoxControlsData.button_pressed:
		return
	
	if FileAccess.file_exists("res://data/ui/controls.json") and not %CheckBoxOverride.button_pressed:
		return
		
	var error_: Error = DirAccess.make_dir_recursive_absolute("res://data/ui")
	if error_ != OK:
		return
		
	DirAccess.copy_absolute(
		"res://addons/retrograde/_/data/ui/controls.json", 
		"res://data/ui/controls.json"
	)

func _create_input_data() -> void:
	if not %CheckBoxInputData.button_pressed:
		return
	
	if FileAccess.file_exists("res://data/input.json") and not %CheckBoxOverride.button_pressed:
		return
		
	var error_: Error = DirAccess.make_dir_recursive_absolute("res://data")
	if error_ != OK:
		return
		
	if not FileAccess.file_exists("res://data/input_resources.json") or %CheckBoxOverride.button_pressed:
		error_ = DirAccess.copy_absolute(
			"res://addons/retrograde/_/data/input_resources.json",
			"res://data/input_resources.json",
		)
		if error_ != OK:
			return
		
	var data_: Dictionary = _load_json("res://addons/retrograde/_/data/input.json")
	data_.enabled = []
	
	if %CheckBoxClimbing.button_pressed:
		data_.enabled.push_back("climb_on")
		data_.enabled.push_back("climb_off")
		data_.enabled.push_back("climb_up")
		data_.enabled.push_back("climb_down")
		data_.enabled.push_back("climb_right")
		data_.enabled.push_back("climb_left")
		
	if %CheckBoxCrouch.button_pressed:
		data_.enabled.push_back("crouch")
		
	if %CheckBoxInteract.button_pressed:
		data_.enabled.push_back("interact")
	
	if %CheckBoxItemDrop.button_pressed:
		data_.enabled.push_back("item_drop")
		
	if %CheckBoxItemPickUp.button_pressed:
		data_.enabled.push_back("item_pick_up")
		
	if %SpinBoxItemSelect.value > 0:
		for i_: int in range(1, %SpinBoxItemSelect.value + 1):
			data_.enabled.push_back("item_select_" + str(i_))
		
	if %CheckBoxItemUse.button_pressed:
		data_.enabled.push_back("item_use")
		
	if %CheckBoxJump.button_pressed:
		data_.enabled.push_back("jump")
	
	if %CheckBoxMovement.button_pressed:
		data_.enabled.push_back("move_up")
		data_.enabled.push_back("move_down")
		data_.enabled.push_back("move_right")
		data_.enabled.push_back("move_left")
	
	var json_: String = JSON.stringify(data_, "\t", false)
	
	var file_: FileAccess = FileAccess.open("res://data/input.json", FileAccess.WRITE)
	file_.store_string(json_)
	file_.close()

func _setup_localization() -> void:
	if not %CheckBoxTranslations.button_pressed:
		return
	
	var error_: Error = DirAccess.make_dir_recursive_absolute("res://data/translations")
	if error_ != OK:
		return
	
	if not FileAccess.file_exists("res://data/translations/input_translations.csv") or %CheckBoxOverride.button_pressed:
		error_ = DirAccess.copy_absolute(
			"res://addons/retrograde/_/data/translations/input_translations.csv",
			"res://data/translations/input_translations.csv",
		)
		if error_ != OK:
			return
	
	if not FileAccess.file_exists("res://data/translations/ui_translations.csv") or %CheckBoxOverride.button_pressed:
		error_ = DirAccess.copy_absolute(
			"res://addons/retrograde/_/data/translations/ui_translations.csv",
			"res://data/translations/ui_translations.csv",
		)
		if error_ != OK:
			return
			
	if not FileAccess.file_exists("res://data/translations/translations.csv") or %CheckBoxOverride.button_pressed:
		error_ = DirAccess.copy_absolute(
			"res://addons/retrograde/_/data/translations/translations.csv",
			"res://data/translations/translations.csv",
		)
		if error_ != OK:
			return
	
	await get_tree().process_frame
	
	EditorInterface.get_resource_filesystem().scan() 
	
	while EditorInterface.get_resource_filesystem().is_scanning():
		await get_tree().process_frame
		
	while not ResourceLoader.exists("res://data/translations/translations.jp.translation"):
		await get_tree().process_frame
		
	var all_: PackedStringArray = [
		"res://data/translations/ui_translations.en.translation",
		"res://data/translations/ui_translations.jp.translation",
		"res://data/translations/input_translations.en.translation",
		"res://data/translations/input_translations.jp.translation",
		"res://data/translations/translations.en.translation",
		"res://data/translations/translations.jp.translation"
	]
		
	var translations_: PackedStringArray = []
	
	if %CheckBoxEnglish.button_pressed:
		translations_.push_back("res://data/translations/ui_translations.en.translation")
		translations_.push_back("res://data/translations/input_translations.en.translation")
		translations_.push_back("res://data/translations/translations.en.translation")
		
	if %CheckBoxJapanese.button_pressed:
		translations_.push_back("res://data/translations/ui_translations.jp.translation")
		translations_.push_back("res://data/translations/input_translations.jp.translation")
		translations_.push_back("res://data/translations/translations.jp.translation")

	var current_: PackedStringArray = ProjectSettings.get_setting("internationalization/locale/translations", [])
	
	for path_: String in current_:
		if all_.has(path_):
			continue
			
		translations_.push_back(path_)

	ProjectSettings.set_setting("internationalization/locale/translations", translations_)

func _load_json(path_: String) -> Dictionary:
	var file_: FileAccess = FileAccess.open(path_, FileAccess.READ)
	if file_ == null:
		return {}
		
	var json_data_: String = file_.get_as_text()
	
	file_.close()
	
	var json_: JSON = JSON.new()

	if json_.parse(json_data_) != OK:
		return {}
		
	return json_.data as Dictionary

func _copy_directory(source_dir_: String, dest_dir_: String, overwrite_: bool = false) -> Error:
	var dir_: DirAccess = DirAccess.open(source_dir_)
	if dir_ == null:
		return DirAccess.get_open_error()
	
	var error_: Error = DirAccess.make_dir_recursive_absolute(dest_dir_)
	if error_ != OK:
		return error_
	
	dir_.list_dir_begin()
	
	var file_name: String = dir_.get_next()
	
	while file_name != "":
		if file_name == "." or file_name == ".." or file_name.ends_with(".import"):
			file_name = dir_.get_next()
			continue
		
		var source_path_: String = source_dir_.path_join(file_name)
		var dest_path_: String = dest_dir_.path_join(file_name)
		
		if dir_.current_is_dir():
			error_ = _copy_directory(source_path_, dest_path_, overwrite_)
		elif not FileAccess.file_exists(dest_path_) or overwrite_:
			error_ = DirAccess.copy_absolute(source_path_, dest_path_)
			
		if error_ != OK:
			dir_.list_dir_end()
			return error_
		
		file_name = dir_.get_next()
	
	dir_.list_dir_end()
	
	return OK

func _on_check_box_audio_bus_layout_toggled(toggled_on_: bool) -> void:
	if toggled_on_:
		%LabelMaster.visible = true
		%CheckBoxMaster.visible = true
		%LabelMusic.visible = true
		%CheckBoxMusic.visible = true
		%LabelAmbiance.visible = true
		%CheckBoxAmbiance.visible = true
		%LabelSFX.visible = true
		%CheckBoxSFX.visible = true
	else:
		%LabelMaster.visible = false
		%CheckBoxMaster.visible = false
		%LabelMusic.visible = false
		%CheckBoxMusic.visible = false
		%LabelAmbiance.visible = false
		%CheckBoxAmbiance.visible = false
		%LabelSFX.visible = false
		%CheckBoxSFX.visible = false

func _on_check_box_main_scene_toggled(toggled_on_: bool) -> void:
	if toggled_on_:
		%LabelLevelController.visible = true
		%CheckBoxLevelController.visible = true
		%LabelAmbianceController.visible = true
		%CheckBoxAmbianceController.visible = true
		%LabelUIController.visible = true
		%CheckBoxUIController.visible = true
		%LabelHUDController.visible = true
		%CheckBoxHUDController.visible = true
		%LabelCamera.visible = true
		%CheckBoxCamera.visible = true
		%LabelPlayerGrid.visible = true
		%CheckBoxPlayerGrid.visible = true
		%LabelDayNightCycle.visible = true
		%CheckBoxDayNightCycle.visible = true
	else:
		%LabelLevelController.visible = false
		%CheckBoxLevelController.visible = false
		%LabelAmbianceController.visible = false
		%CheckBoxAmbianceController.visible = false
		%LabelUIController.visible = false
		%CheckBoxUIController.visible = false
		%LabelHUDController.visible = false
		%CheckBoxHUDController.visible = false
		%LabelCamera.visible = false
		%CheckBoxCamera.visible = false
		%LabelPlayerGrid.visible = false
		%CheckBoxPlayerGrid.visible = false
		%LabelDayNightCycle.visible = false
		%CheckBoxDayNightCycle.visible = false

func _on_check_box_ui_level_select_toggled(toggled_on_: bool) -> void:
	if toggled_on_:
		%LabelUILevelSkip.visible = true
		%CheckBoxUILevelSkip.visible = true
		%LabelUILevelNext.visible = true
		%CheckBoxUILevelNext.visible = true
		%LabelUILevelPrevious.visible = true
		%CheckBoxUILevelPrevious.visible = true
	else:
		%LabelUILevelSkip.visible = false
		%CheckBoxUILevelSkip.visible = false
		%LabelUILevelNext.visible = false
		%CheckBoxUILevelNext.visible = false
		%LabelUILevelPrevious.visible = false
		%CheckBoxUILevelPrevious.visible = false
