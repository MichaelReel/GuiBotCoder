class_name InstructionGui
extends Tree

@export var plus_button_texture2d: Texture2D
@export var minus_button_texture2d: Texture2D
@export var modify_button_texture2d: Texture2D

var root: EntityGui

@onready var add_property_popup_panel: PopupPanel = $AddPropertyPopupPanel
@onready var edit_property_popup_panel: PopupPanel = $EditPropertyPopupPanel
@onready var delete_property_popup_panel: PopupPanel = $DeletePropertyPopupPanel
@onready var add_variable_popup_panel: PopupPanel = $AddVariablePopupPanel
@onready var edit_variable_popup_panel: PopupPanel = $EditVariablePopupPanel
@onready var delete_variable_popup_panel: PopupPanel = $DeleteVariablePopupPanel

func _ready() -> void:
	set_column_expand(Column.TITLE, true)
	set_column_expand(Column.ADD_BUTTON, false)
	set_column_expand(Column.REMOVE_BUTTON, false)
	set_column_expand(Column.EDIT_BUTTON, false)
	set_column_custom_minimum_width(Column.ADD_BUTTON, plus_button_texture2d.get_width())
	set_column_custom_minimum_width(Column.REMOVE_BUTTON, minus_button_texture2d.get_width())
	set_column_custom_minimum_width(Column.EDIT_BUTTON, modify_button_texture2d.get_width())
	
	# Test Load
	var file_access: AIFileAccess = AIFileAccess.new()
	var entity: AIEntity = file_access.load_file("test_ai_entity.json")
	
	hide_root = true
	root = EntityGui.new(self, entity)
	
	# Save back to test file to see changes in git diff
	file_access.save_file(entity, "test_ai_entity.json")

func _on_button_clicked(item: TreeItem, _column: int, id: int, _mouse_button_index: int) -> void:
	match id:
		EditType.ADD_PROPERTY:
			add_property_popup_panel.show_add()
		EditType.ADD_VARIABLE:
			add_variable_popup_panel.show_add()
		EditType.ADD_STATE:
			print("ADD_STATE: ", str(item))
		EditType.ADD_ACTION:
			print("ADD_ACTION: ", str(item))
		EditType.ADD_TRANSISTION:
			print("ADD_TRANSISTION: ", str(item))
		EditType.ADD_CONDITION:
			print("ADD_CONDITION: ", str(item))
		EditType.EDIT_PROPERTY:
			edit_property_popup_panel.show_edit(item, root.get_property_name_by_treeitem(item))
		EditType.EDIT_VARIABLE:
			edit_variable_popup_panel.show_edit(item, root.get_variable_name_by_treeitem(item))
		EditType.EDIT_STATE:
			print("EDIT_STATE: ", str(item))
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
			print("REMOVE_STATE: ", str(item))
		EditType.REMOVE_ACTION:
			print("REMOVE_ACTION: ", str(item))
		EditType.REMOVE_TRANSISTION:
			print("REMOVE_TRANSISTION: ", str(item))
		EditType.REMOVE_CONDITION:
			print("REMOVE_CONDITION: ", str(item))

func _get_random_direction() -> Vector2:
	return Vector2.from_angle(randf_range(0, PI * 2.0))

func _on_add_property_popup_panel_add_property(property_name: String) -> void:
	root.add_property(property_name)

func _on_edit_property_popup_panel_edit_property(treeitem: TreeItem, property_name: String) -> void:
	root.edit_property_by_treeitem(treeitem, property_name)

func _on_delete_property_popup_panel_delete_property(treeitem: TreeItem) -> void:
	root.delete_property_by_treeitem(treeitem)

func _on_add_variable_popup_panel_add_variable(variable_name: String) -> void:
	root.add_variable(variable_name)

func _on_edit_variable_popup_panel_edit_variable(treeitem: TreeItem, variable_name: String) -> void:
	root.edit_variable_by_treeitem(treeitem, variable_name)

func _on_delete_variable_popup_panel_delete_variable(treeitem: TreeItem) -> void:
	root.delete_variable_by_treeitem(treeitem)
