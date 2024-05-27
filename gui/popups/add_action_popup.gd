extends PopupPanel

signal add_action(state_treeitem: TreeItem, action_name: String)


func _ready() -> void:
	_set_to_center()

func show_add() -> void:
	show()

func _set_to_center() -> void:
	position = (DisplayServer.window_get_size() / 2) - (size / 2)

func _close() -> void:
	visible = false

func _on_add_button_pressed() -> void:
	_close()

func _on_cancel_button_pressed() -> void:
	_close()
