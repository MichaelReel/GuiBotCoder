@tool
extends PopupPanel

signal add_assignment(item: TreeItem, state_gui: StateGui, variable_name: String, function_name: String, argument_names: Array[String])

@onready var variable_name_field: LineEdit = %VariableNameField
@onready var function_name_field: LineEdit = %FunctionNameField
@onready var add_argument_menu_button: MenuButton = %AddArgumentMenuButton
@onready var argument_list: ItemList = %ArgumentList

var _item: TreeItem
var _state_gui: StateGui
var idx_property_mapping: Array[String] = []

func _ready() -> void:
	add_argument_menu_button.get_popup().connect("index_pressed", self._menu_button_popup_index_pressed)
	_set_to_center()

func show_add(item: TreeItem, state_gui: StateGui, available_arguments: Array[String]) -> void:
	_item = item
	_state_gui = state_gui
	variable_name_field.grab_focus()
	
	add_argument_menu_button.get_popup().clear(true)
	idx_property_mapping.clear()
	for argument in available_arguments:
		add_argument_menu_button.get_popup().add_item(argument)
		idx_property_mapping.append(argument)
	
	show()

func _menu_button_popup_index_pressed(index: int) -> void:
	argument_list.add_item(idx_property_mapping[index], null, false)

func _set_to_center() -> void:
	position = (DisplayServer.window_get_size() / 2) - (size / 2)

func _close() -> void:
	visible = false

func _on_add_button_pressed() -> void:
	var variable_name: String = variable_name_field.text.strip_edges()
	var function_name: String = function_name_field.text.strip_edges()
	var argument_names: Array[String] = _get_items_as_strings(argument_list)
	
	if variable_name and function_name:
		emit_signal("add_assignment", _item, _state_gui, variable_name, function_name, argument_names)
		variable_name_field.text = ""
		function_name_field.text = ""
		argument_list.clear()
		_close()

func _on_cancel_button_pressed() -> void:
	_close()

func _get_items_as_strings(item_list: ItemList) -> Array[String]:
	var item_names: Array[String] = []
	for idx in range(item_list.item_count):
		item_names.append(item_list.get_item_text(idx))
	return item_names
