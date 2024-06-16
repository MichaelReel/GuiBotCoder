@tool
class_name InstructionGui
extends Tree

signal file_selected(path: String)

@export var plus_button_texture2d: Texture2D
@export var minus_button_texture2d: Texture2D
@export var modify_button_texture2d: Texture2D

@onready var file_access: AIFileAccess = AIFileAccess.new()

var root: EntityGui

var add_property_popup_panel: PopupPanel
var add_variable_popup_panel: PopupPanel
var add_state_popup_panel: PopupPanel
var add_action_popup_panel: PopupPanel
var add_action_assignment_popup_panel: PopupPanel
var add_action_travel_popup_panel: PopupPanel
var add_action_perform_popup_panel: PopupPanel
var edit_property_popup_panel: PopupPanel
var edit_variable_popup_panel: PopupPanel
var edit_state_popup_panel: PopupPanel
var delete_property_popup_panel: PopupPanel
var delete_variable_popup_panel: PopupPanel
var delete_state_popup_panel: PopupPanel

var file_dialog: FileDialog

var current_path: String
var current_entity: AIEntity
var path_entity_mapping: Dictionary = {}

func _ready() -> void:
	set_column_expand(Column.TITLE, true)
	set_column_expand(Column.ADD_BUTTON, false)
	set_column_expand(Column.REMOVE_BUTTON, false)
	set_column_expand(Column.EDIT_BUTTON, false)
	set_column_custom_minimum_width(Column.ADD_BUTTON, plus_button_texture2d.get_width())
	set_column_custom_minimum_width(Column.REMOVE_BUTTON, minus_button_texture2d.get_width())
	set_column_custom_minimum_width(Column.EDIT_BUTTON, modify_button_texture2d.get_width())
	hide_root = true

func set_window_signals(window_list: Dictionary) -> void:
	# Get a first-party reference to the popups
	add_property_popup_panel = window_list["add_property_popup_panel"]
	add_variable_popup_panel = window_list["add_variable_popup_panel"]
	add_state_popup_panel = window_list["add_state_popup_panel"]
	add_action_popup_panel = window_list["add_action_popup_panel"]
	add_action_assignment_popup_panel = window_list["add_action_assignment_popup_panel"]
	add_action_travel_popup_panel = window_list["add_action_travel_popup_panel"]
	add_action_perform_popup_panel = window_list["add_action_perform_popup_panel"]
	edit_property_popup_panel = window_list["edit_property_popup_panel"]
	edit_variable_popup_panel = window_list["edit_variable_popup_panel"]
	edit_state_popup_panel = window_list["edit_state_popup_panel"]
	delete_property_popup_panel = window_list["delete_property_popup_panel"]
	delete_variable_popup_panel = window_list["delete_variable_popup_panel"]
	delete_state_popup_panel = window_list["delete_state_popup_panel"]
	file_dialog = window_list["file_dialog"]
	
	# Hook into the popup signals
	add_property_popup_panel.connect("add_property", self._on_add_property_popup_panel_add_property)
	add_variable_popup_panel.connect("add_variable", self._on_add_variable_popup_panel_add_variable)
	add_state_popup_panel.connect("add_state", self._on_add_state_popup_panel_add_state)
	add_action_popup_panel.connect("assign_selected", self._on_add_action_popup_panel_assign_selected)
	add_action_popup_panel.connect("travel_selected", self._on_add_action_popup_panel_travel_selected)
	add_action_popup_panel.connect("stop_selected", self._on_add_action_popup_panel_stop_selected)
	add_action_popup_panel.connect("perform_selected", self._on_add_action_popup_panel_perform_selected)
	add_action_assignment_popup_panel.connect("add_assignment", self._on_add_action_assignment_popup_panel_add_assignment)
	add_action_travel_popup_panel.connect("add_travel", self._on_add_action_travel_popup_panel_add_travel)
	add_action_perform_popup_panel.connect("add_perform", self._on_add_action_perform_popup_panel_add_perform)
	edit_property_popup_panel.connect("edit_property", self._on_edit_property_popup_panel_edit_property)
	edit_variable_popup_panel.connect("edit_variable", self._on_edit_variable_popup_panel_edit_variable)
	edit_state_popup_panel.connect("edit_state", self._on_edit_state_popup_panel_edit_state)
	delete_property_popup_panel.connect("delete_property", self._on_delete_property_popup_panel_delete_property)
	delete_variable_popup_panel.connect("delete_variable", self._on_delete_variable_popup_panel_delete_variable)
	delete_state_popup_panel.connect("delete_state", self._on_delete_state_popup_panel_delete_state)
	file_dialog.connect("file_selected", self._on_state_machine_file_dialog_file_selected)

func _on_select_button_pressed() -> void:
	file_dialog.show()

func _on_state_machine_file_dialog_file_selected(path: String) -> void:
	# Don't change anything if we already have this file open
	if current_path == path:
		return
	
	# Check if we have a path already loaded in the disctionary
	current_path = path
	if current_path in path_entity_mapping:
		current_entity = path_entity_mapping[current_path]
	else:
		# If the file doesn't exist, create it
		if not file_access.file_exists(current_path):
			file_access.save_file(AIEntity.new(current_path), current_path)
		
		# Load current_entity state machine
		current_entity = file_access.load_file(current_path)
		path_entity_mapping[current_path] = current_entity
	
	_update_gui_to_current_entity()

func load_existing_machine(path: String) -> void:
	current_path = path
	current_entity = path_entity_mapping[current_path]
	
	_update_gui_to_current_entity()

func _update_gui_to_current_entity() -> void:
	# Clear the tree and update the GUI
	clear()
	root = EntityGui.new(self, current_entity)
	emit_signal("file_selected", current_path)

func _on_button_clicked(item: TreeItem, _column: int, id: int, _mouse_button_index: int) -> void:
	match id:
		EditType.ADD_PROPERTY:
			add_property_popup_panel.show_add()
		EditType.ADD_VARIABLE:
			add_variable_popup_panel.show_add()
		EditType.ADD_STATE:
			add_state_popup_panel.show_add()
		EditType.ADD_ACTION:
			add_action_popup_panel.show_add(item, root.find_stategui_by_treeitem(item.get_parent()))
		EditType.ADD_TRANSISTION:
			print("ADD_TRANSISTION: ", str(item))
		EditType.ADD_CONDITION:
			print("ADD_CONDITION: ", str(item))
		EditType.EDIT_PROPERTY:
			edit_property_popup_panel.show_edit(item, root.get_property_name_by_treeitem(item))
		EditType.EDIT_VARIABLE:
			edit_variable_popup_panel.show_edit(item, root.get_variable_name_by_treeitem(item))
		EditType.EDIT_STATE:
			edit_state_popup_panel.show_edit(item, root.get_state_name_by_treeitem(item))
		EditType.EDIT_ACTION:
			print("EDIT_ACTION: ", str(item))
		EditType.EDIT_TRANSISTION:
			print("EDIT_TRANSISTION: ", str(item))
		EditType.EDIT_CONDITION:
			print("EDIT_CONDITION: ", str(item))
		EditType.REMOVE_PROPERTY:
			delete_property_popup_panel.show_delete(item, root.get_property_name_by_treeitem(item))
		EditType.REMOVE_VARIABLE:
			delete_variable_popup_panel.show_delete(item, root.get_variable_name_by_treeitem(item))
		EditType.REMOVE_STATE:
			delete_state_popup_panel.show_delete(item, root.get_state_name_by_treeitem(item))
		EditType.REMOVE_ACTION:
			print("REMOVE_ACTION: ", str(item))
		EditType.REMOVE_TRANSISTION:
			print("REMOVE_TRANSISTION: ", str(item))
		EditType.REMOVE_CONDITION:
			print("REMOVE_CONDITION: ", str(item))

#region: Properties

func _on_add_property_popup_panel_add_property(property_name: String) -> void:
	root.add_property(property_name)
	file_access.save_file(current_entity, current_path)

func _on_edit_property_popup_panel_edit_property(treeitem: TreeItem, property_name: String) -> void:
	root.edit_property_by_treeitem(treeitem, property_name)
	file_access.save_file(current_entity, current_path)

func _on_delete_property_popup_panel_delete_property(treeitem: TreeItem) -> void:
	root.delete_property_by_treeitem(treeitem)
	file_access.save_file(current_entity, current_path)

#endregion

#region: Variables

func _on_add_variable_popup_panel_add_variable(variable_name: String) -> void:
	root.add_variable(variable_name)
	file_access.save_file(current_entity, current_path)

func _on_edit_variable_popup_panel_edit_variable(treeitem: TreeItem, variable_name: String) -> void:
	root.edit_variable_by_treeitem(treeitem, variable_name)
	file_access.save_file(current_entity, current_path)

func _on_delete_variable_popup_panel_delete_variable(treeitem: TreeItem) -> void:
	root.delete_variable_by_treeitem(treeitem)
	file_access.save_file(current_entity, current_path)

#endregion

#region: States

func _on_add_state_popup_panel_add_state(state_name: String) -> void:
	root.add_state(state_name)
	file_access.save_file(current_entity, current_path)

func _on_edit_state_popup_panel_edit_state(treeitem: TreeItem, state_name: String) -> void:
	root.edit_state_by_treeitem(treeitem, state_name)
	file_access.save_file(current_entity, current_path)

func _on_delete_state_popup_panel_delete_state(treeitem: TreeItem) -> void:
	root.delete_state_by_treeitem(treeitem)
	file_access.save_file(current_entity, current_path)

#endregion

#region: Actions

func _on_add_action_popup_panel_assign_selected(item: TreeItem, state_gui: StateGui) -> void:
	var argument_list: Array[String] = []
	argument_list.append_array(root.get_property_names())
	argument_list.append_array(root.get_variable_names())
	argument_list.append_array(state_gui.get_assigned_variable_names())
	add_action_assignment_popup_panel.show_add(item, state_gui, argument_list)

func _on_add_action_popup_panel_travel_selected(item: TreeItem, state_gui: StateGui) -> void:
	var argument_list: Array[String] = []
	argument_list.append_array(root.get_property_names())
	argument_list.append_array(root.get_variable_names())
	argument_list.append_array(state_gui.get_assigned_variable_names())
	add_action_travel_popup_panel.show_add(item, state_gui, argument_list)

func _on_add_action_popup_panel_perform_selected(item: TreeItem, state_gui: StateGui) -> void:
	var argument_list: Array[String] = []
	argument_list.append_array(root.get_property_names())
	argument_list.append_array(root.get_variable_names())
	argument_list.append_array(state_gui.get_assigned_variable_names())
	add_action_perform_popup_panel.show_add(item, state_gui, argument_list)

func _on_add_action_popup_panel_stop_selected(item: TreeItem, state_gui: StateGui) -> void:
	# I don't think we need a popup for "stop"
	root.add_stop_to_state(state_gui)
	# TODO: file_access.save_file(current_entity, current_path)

func _on_add_action_assignment_popup_panel_add_assignment(
	item: TreeItem, state_gui: StateGui, variable_name: String, function_name: String, argument_names: Array[String]
) -> void:
	root.add_assignment_to_state(state_gui, variable_name, function_name, argument_names)
	# TODO: file_access.save_file(current_entity, current_path)

func _on_add_action_travel_popup_panel_add_travel(
	item: TreeItem, state_gui: StateGui, direction_variable_name: String, distance_variable_name: String
) -> void:
	root.add_travel_to_state(state_gui, direction_variable_name, distance_variable_name)
	# TODO: file_access.save_file(current_entity, current_path)

func _on_add_action_perform_popup_panel_add_perform(
	item: TreeItem, state_gui: StateGui, function_name: String, argument_names: Array[String]
) -> void:
	root.add_perform_to_state(state_gui, function_name, argument_names)
	# TODO: file_access.save_file(current_entity, current_path)

#endregion
