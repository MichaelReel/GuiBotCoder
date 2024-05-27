@tool
extends EditorPlugin

var editor_panel_scene: PackedScene = preload("res://addons/smm/gui/code_gui.tscn")
var editor_panel: Control

func _enter_tree() -> void:
	editor_panel = editor_panel_scene.instantiate()
	add_control_to_bottom_panel(editor_panel, "State Machine")


func _exit_tree() -> void:
	remove_control_from_bottom_panel(editor_panel)
	editor_panel.free()
