@tool
extends PopupPanel

signal add_travel(item: TreeItem, state_gui: StateGui, direction_variable_name: String, distance_variable_name: String)

@onready var direction_name_field: OptionButton = %DirectionOptionButton
@onready var distance_name_field: OptionButton = %DistanceOptionButton

var _item: TreeItem
var _state_gui: StateGui
var idx_property_mapping: Array[String] = []

func _ready() -> void:
	_set_to_center()

func show_add(item: TreeItem, state_gui: StateGui, available_arguments: Array[String]) -> void:
	_item = item
	_state_gui = state_gui
	direction_name_field.grab_focus()
	
	direction_name_field.clear()
	distance_name_field.clear()
	idx_property_mapping.clear()
	
	for argument in available_arguments:
		direction_name_field.add_item(argument)
		distance_name_field.add_item(argument)
		idx_property_mapping.append(argument)
	
	show()

func _set_to_center() -> void:
	position = (DisplayServer.window_get_size() / 2) - (size / 2)

func _close() -> void:
	visible = false

func _on_add_button_pressed() -> void:
	var direction_ind: int = direction_name_field.selected
	var distance_ind: int = distance_name_field.selected
	
	if direction_ind >= 0 and distance_ind >= 0:
		var direction_variable_name: String = idx_property_mapping[direction_ind]
		var distance_variable_name: String = idx_property_mapping[distance_ind]
		
		emit_signal("add_travel", _item, _state_gui, direction_variable_name, distance_variable_name)
		direction_name_field.select(-1)
		distance_name_field.select(-1)
		_close()

func _on_cancel_button_pressed() -> void:
	_close()
