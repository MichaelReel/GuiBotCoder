extends PopupPanel

signal edit_state(treeitem: TreeItem, state_name: String)

var _treeitem: TreeItem

@onready var state_name_field: LineEdit = $VBoxContainer/StateNameField

func _ready() -> void:
	_set_to_center()

func show_edit(treeitem: TreeItem, state_name: String) -> void:
	_treeitem = treeitem
	state_name_field.text = state_name
	state_name_field.grab_focus()
	show()

func _set_to_center() -> void:
	position = (DisplayServer.window_get_size() / 2) - (size / 2)

func _on_edit_button_pressed() -> void:
	emit_signal("edit_state", _treeitem, state_name_field.text)
	hide()

func _on_cancel_button_pressed() -> void:
	hide()

