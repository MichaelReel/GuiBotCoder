extends PopupPanel

signal edit_variable(treeitem: TreeItem, variable_name: String)

var _treeitem: TreeItem

@onready var variable_name_field: LineEdit = $VBoxContainer/VariableNameField

func _ready() -> void:
	_set_to_center()

func show_edit(treeitem: TreeItem, variable_name: String) -> void:
	_treeitem = treeitem
	variable_name_field.text = variable_name
	variable_name_field.grab_focus()
	show()

func _set_to_center() -> void:
	position = (DisplayServer.window_get_size() / 2) - (size / 2)

func _on_edit_button_pressed() -> void:
	emit_signal("edit_variable", _treeitem, variable_name_field.text)
	hide()

func _on_cancel_button_pressed() -> void:
	hide()

