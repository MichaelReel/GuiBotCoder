extends PopupPanel

signal delete_state(treeitem: TreeItem)

var _treeitem: TreeItem

@onready var state_name_field: LineEdit = $VBoxContainer/StateNameField

func _ready() -> void:
	_set_to_center()

func show_delete(treeitem: TreeItem, state_name: String) -> void:
	_treeitem = treeitem
	state_name_field.text = state_name
	show()

func _set_to_center() -> void:
	position = (DisplayServer.window_get_size() / 2) - (size / 2)

func _on_delete_button_pressed() -> void:
	emit_signal("delete_state", _treeitem)
	hide()

func _on_cancel_button_pressed() -> void:
	hide()
