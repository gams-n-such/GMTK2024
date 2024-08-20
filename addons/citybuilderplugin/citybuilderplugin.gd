@tool
extends EditorPlugin

var tool_panel
const tool_panel_scene = preload("res://addons/citybuilderplugin/panel.tscn")




func _enter_tree():
	tool_panel = tool_panel_scene.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, tool_panel)


func _exit_tree():
	EditorInterface.get_base_control().mouse_entered
	remove_control_from_docks(tool_panel)
	tool_panel.queue_free()
	pass
