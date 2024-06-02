@tool
class_name SmmControl
extends Control

@onready var instruction_tree: InstructionGui = %InstructionGui
@onready var machine_list: ItemList = %MachineList
@onready var window_list: Dictionary = {
	"add_property_popup_panel": preload("res://addons/smm/gui/popups/property/add_property_popup_panel.tscn").instantiate(),
	"add_variable_popup_panel": preload("res://addons/smm/gui/popups/variable/add_variable_popup_panel.tscn").instantiate(),
	"add_state_popup_panel": preload("res://addons/smm/gui/popups/state/add_state_popup_panel.tscn").instantiate(),
	"add_action_popup_panel": preload("res://addons/smm/gui/popups/action/add_action_popup_panel.tscn").instantiate(),
	"edit_property_popup_panel": preload("res://addons/smm/gui/popups/property/edit_property_popup_panel.tscn").instantiate(),
	"edit_variable_popup_panel": preload("res://addons/smm/gui/popups/variable/edit_variable_popup_panel.tscn").instantiate(),
	"edit_state_popup_panel": preload("res://addons/smm/gui/popups/state/edit_state_popup_panel.tscn").instantiate(),
	"delete_property_popup_panel": preload("res://addons/smm/gui/popups/property/delete_property_popup_panel.tscn").instantiate(),
	"delete_variable_popup_panel": preload("res://addons/smm/gui/popups/variable/delete_variable_popup_panel.tscn").instantiate(),
	"delete_state_popup_panel": preload("res://addons/smm/gui/popups/state/delete_state_popup_panel.tscn").instantiate(),
	"delete_action_popup_panel": preload("res://addons/smm/gui/popups/action/delete_action_popup_panel.tscn").instantiate(),
	"file_dialog": preload("res://addons/smm/gui/popups/state_machine_file_dialog.tscn").instantiate(),
}

var file_paths: Array[String] = []

func _ready() -> void:
	instruction_tree.set_window_signals(window_list)
	
	if not Engine.is_editor_hint():
		for window in window_list.values():
			add_child(window)

func get_extra_windows() -> Dictionary:
	return window_list

func _on_instruction_gui_file_selected(path: String) -> void:
	var ind: int = file_paths.bsearch(path)
	
	if ind >= len(file_paths) or file_paths[ind] != path:
		# Insert path into 
		file_paths.insert(ind, path)
		machine_list.move_item(machine_list.add_item(path), ind)
	
	machine_list.select(ind)

func _on_machine_list_item_selected(index: int) -> void:
	instruction_tree.load_existing_machine(file_paths[index])
