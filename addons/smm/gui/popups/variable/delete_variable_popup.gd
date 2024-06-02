@tool
extends PopupPanel

signal delete_variable(treeitem: TreeItem)

var _treeitem: TreeItem

@onready var variable_name_field: LineEdit = $VBoxContainer/VariableNameField

func _ready() -> void:
	_set_to_center()

func show_delete(treeitem: TreeItem, variable_name: String) -> void:
	_treeitem = treeitem
	variable_name_field.text = variable_name
	show()

func _set_to_center() -> void:
	position = (DisplayServer.window_get_size() / 2) - (size / 2)

func _on_delete_button_pressed() -> void:
	emit_signal("delete_variable", _treeitem)
	hide()

func _on_cancel_button_pressed() -> void:
	hide()
