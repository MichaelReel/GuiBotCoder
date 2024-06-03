@tool
extends PopupPanel

signal edit_property(treeitem: TreeItem, property_name: String)

var _treeitem: TreeItem

@onready var property_name_field: LineEdit = $VBoxContainer/PropertyNameField

func _ready() -> void:
	_set_to_center()

func show_edit(treeitem: TreeItem, property_name: String) -> void:
	_treeitem = treeitem
	property_name_field.text = property_name
	property_name_field.grab_focus()
	show()

func _set_to_center() -> void:
	position = (DisplayServer.window_get_size() / 2) - (size / 2)

func _on_edit_button_pressed() -> void:
	var property_name: String = property_name_field.text.strip_edges()
	if property_name:
		emit_signal("edit_property", _treeitem, property_name)
		hide()

func _on_cancel_button_pressed() -> void:
	hide()

