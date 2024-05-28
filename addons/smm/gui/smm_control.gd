@tool
class_name SmmControl
extends Control

@onready var instruction_tree: InstructionGui = %InstructionGui
@onready var machine_list: ItemList = %MachineList

@onready var add_property_popup_panel: PopupPanel = preload("res://addons/smm/gui/popups/add_property_popup_panel.tscn").instantiate()
@onready var add_variable_popup_panel: PopupPanel = preload("res://addons/smm/gui/popups/add_variable_popup_panel.tscn").instantiate()
@onready var add_state_popup_panel: PopupPanel = preload("res://addons/smm/gui/popups/add_state_popup_panel.tscn").instantiate()
@onready var add_action_popup_panel: PopupPanel = preload("res://addons/smm/gui/popups/add_action_popup_panel.tscn").instantiate()
@onready var edit_property_popup_panel: PopupPanel = preload("res://addons/smm/gui/popups/edit_property_popup_panel.tscn").instantiate()
@onready var edit_variable_popup_panel: PopupPanel = preload("res://addons/smm/gui/popups/edit_variable_popup_panel.tscn").instantiate()
@onready var edit_state_popup_panel: PopupPanel = preload("res://addons/smm/gui/popups/edit_state_popup_panel.tscn").instantiate()
@onready var delete_property_popup_panel: PopupPanel = preload("res://addons/smm/gui/popups/delete_property_popup_panel.tscn").instantiate()
@onready var delete_variable_popup_panel: PopupPanel = preload("res://addons/smm/gui/popups/delete_variable_popup_panel.tscn").instantiate()
@onready var delete_state_popup_panel: PopupPanel = preload("res://addons/smm/gui/popups/delete_state_popup_panel.tscn").instantiate()
@onready var file_dialog: FileDialog = preload("res://addons/smm/gui/popups/state_machine_file_dialog.tscn").instantiate()

@onready var window_list: Dictionary = {
	"add_property_popup_panel": add_property_popup_panel,
	"add_variable_popup_panel": add_variable_popup_panel,
	"add_state_popup_panel": add_state_popup_panel,
	"add_action_popup_panel": add_action_popup_panel,
	"edit_property_popup_panel": edit_property_popup_panel,
	"edit_variable_popup_panel": edit_variable_popup_panel,
	"edit_state_popup_panel": edit_state_popup_panel,
	"delete_property_popup_panel": delete_property_popup_panel,
	"delete_variable_popup_panel": delete_variable_popup_panel,
	"delete_state_popup_panel": delete_state_popup_panel,
	"file_dialog": file_dialog,
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
