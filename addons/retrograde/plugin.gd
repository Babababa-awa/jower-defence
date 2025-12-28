@tool
extends EditorPlugin

var bottom_panel: Control

func _enable_plugin() -> void:
	# Add autoloads here.
	pass

func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

func _enter_tree() -> void:
	_load_bottom_panel()

func _exit_tree() -> void:
	remove_control_from_bottom_panel(bottom_panel)
	
func _load_bottom_panel() -> void:
	bottom_panel = preload("res://addons/retrograde/plugin/bottom_panel.tscn").instantiate()
			
	add_control_to_bottom_panel(bottom_panel, "Retrograde")
