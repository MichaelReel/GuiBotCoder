@tool
extends EditorPlugin

var smm_control_scene: PackedScene = preload("res://addons/smm/gui/smm_control.tscn")
var smm_control: SmmControl
var windows: Array[Window]

func _enter_tree() -> void:
	smm_control = smm_control_scene.instantiate()
	add_control_to_bottom_panel(smm_control, "State Machine")
	
	windows = smm_control.get_extra_windows()
	for window in windows:
		get_editor_interface().get_base_control().add_child(window)


func _exit_tree() -> void:
	for window in windows:
		get_editor_interface().get_base_control().remove_child(window)
		window.queue_free()
		
	remove_control_from_bottom_panel(smm_control)
	smm_control.queue_free()
