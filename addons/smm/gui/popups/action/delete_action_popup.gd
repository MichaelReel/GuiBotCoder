@tool
extends PopupPanel

signal delete_action(treeitem: TreeItem)

var _treeitem: TreeItem

@onready var action_name_field: LineEdit = $VBoxContainer/ActionNameField

func _ready() -> void:
	_set_to_center()

func show_delete(treeitem: TreeItem, action_name: String) -> void:
	_treeitem = treeitem
	action_name_field.text = action_name
	show()

func _set_to_center() -> void:
	position = (DisplayServer.window_get_size() / 2) - (size / 2)

func _on_delete_button_pressed() -> void:
	emit_signal("delete_action", _treeitem)
	hide()

func _on_cancel_button_pressed() -> void:
	hide()
