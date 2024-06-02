@tool
extends PopupPanel

signal delete_property(treeitem: TreeItem)

var _treeitem: TreeItem

@onready var property_name_field: LineEdit = $VBoxContainer/PropertyNameField

func _ready() -> void:
	_set_to_center()

func show_delete(treeitem: TreeItem, property_name: String) -> void:
	_treeitem = treeitem
	property_name_field.text = property_name
	show()

func _set_to_center() -> void:
	position = (DisplayServer.window_get_size() / 2) - (size / 2)

func _on_delete_button_pressed() -> void:
	emit_signal("delete_property", _treeitem)
	hide()

func _on_cancel_button_pressed() -> void:
	hide()
