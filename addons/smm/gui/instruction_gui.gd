@tool
class_name InstructionGui
extends Tree

@export var plus_button_texture2d: Texture2D
@export var minus_button_texture2d: Texture2D
@export var modify_button_texture2d: Texture2D

@onready var file_access: AIFileAccess = AIFileAccess.new()

var root: EntityGui

var add_property_popup_panel: PopupPanel
var add_variable_popup_panel: PopupPanel
var add_state_popup_panel: PopupPanel
var add_action_popup_panel: PopupPanel
var edit_property_popup_panel: PopupPanel
var edit_variable_popup_panel: PopupPanel
var edit_state_popup_panel: PopupPanel
var delete_property_popup_panel: PopupPanel
var delete_variable_popup_panel: PopupPanel
var delete_state_popup_panel: PopupPanel

var file_dialog: FileDialog
var path: String
var entity: AIEntity

func _ready() -> void:
	set_column_expand(Column.TITLE, true)
	set_column_expand(Column.ADD_BUTTON, false)
	set_column_expand(Column.REMOVE_BUTTON, false)
	set_column_expand(Column.EDIT_BUTTON, false)
	set_column_custom_minimum_width(Column.ADD_BUTTON, plus_button_texture2d.get_width())
	set_column_custom_minimum_width(Column.REMOVE_BUTTON, minus_button_texture2d.get_width())
	set_column_custom_minimum_width(Column.EDIT_BUTTON, modify_button_texture2d.get_width())

func set_window_signals(window_list: Dictionary) -> void:
	# Get a first-party reference to the popups
	add_property_popup_panel = window_list["add_property_popup_panel"]
	add_variable_popup_panel = window_list["add_variable_popup_panel"]
	add_state_popup_panel = window_list["add_state_popup_panel"]
	add_action_popup_panel = window_list["add_action_popup_panel"]
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
	#add_action_popup_panel.connect("add_action", self._on_add_action_popup_panel_add_action)
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
	print("File Selected!: ", path)
	
	if self.path == path:
		return
	self.path = path
	
	## Test Load
	entity = file_access.load_file(path)
	
	hide_root = true
	root = EntityGui.new(self, entity)

func _on_button_clicked(item: TreeItem, _column: int, id: int, _mouse_button_index: int) -> void:
	match id:
		EditType.ADD_PROPERTY:
			add_property_popup_panel.show_add()
		EditType.ADD_VARIABLE:
			add_variable_popup_panel.show_add()
		EditType.ADD_STATE:
			add_state_popup_panel.show_add()
		EditType.ADD_ACTION:
			add_action_popup_panel.show_add()
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
	file_access.save_file(entity, path)

func _on_edit_property_popup_panel_edit_property(treeitem: TreeItem, property_name: String) -> void:
	root.edit_property_by_treeitem(treeitem, property_name)
	file_access.save_file(entity, path)

func _on_delete_property_popup_panel_delete_property(treeitem: TreeItem) -> void:
	root.delete_property_by_treeitem(treeitem)
	file_access.save_file(entity, path)

#endregion

#region: Variables

func _on_add_variable_popup_panel_add_variable(variable_name: String) -> void:
	root.add_variable(variable_name)
	file_access.save_file(entity, path)

func _on_edit_variable_popup_panel_edit_variable(treeitem: TreeItem, variable_name: String) -> void:
	root.edit_variable_by_treeitem(treeitem, variable_name)
	file_access.save_file(entity, path)

func _on_delete_variable_popup_panel_delete_variable(treeitem: TreeItem) -> void:
	root.delete_variable_by_treeitem(treeitem)
	file_access.save_file(entity, path)

#endregion

#region: States

func _on_add_state_popup_panel_add_state(state_name: String) -> void:
	root.add_state(state_name)
	file_access.save_file(entity, path)

func _on_edit_state_popup_panel_edit_state(treeitem: TreeItem, state_name: String) -> void:
	root.edit_state_by_treeitem(treeitem, state_name)
	file_access.save_file(entity, path)

func _on_delete_state_popup_panel_delete_state(treeitem: TreeItem) -> void:
	root.delete_state_by_treeitem(treeitem)
	file_access.save_file(entity, path)

#endregion

#region: Actions

#endregion
