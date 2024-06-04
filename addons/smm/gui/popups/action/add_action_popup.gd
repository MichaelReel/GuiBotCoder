@tool
extends PopupPanel

signal assign_selected(item: TreeItem, state_gui: StateGui)
signal travel_selected(item: TreeItem, state_gui: StateGui)
signal stop_selected(item: TreeItem, state_gui: StateGui)
signal perform_selected(item: TreeItem, state_gui: StateGui)

var _item: TreeItem
var _state_gui: StateGui

func _ready() -> void:
	_set_to_center()

func show_add(item: TreeItem, state_gui: StateGui) -> void:
	_item = item
	_state_gui = state_gui
	show()

func _set_to_center() -> void:
	position = (DisplayServer.window_get_size() / 2) - (size / 2)

func _close() -> void:
	visible = false

func _on_cancel_button_pressed() -> void:
	_close()

func _on_assign_button_pressed() -> void:
	emit_signal("assign_selected", _item, _state_gui)
	_close()

func _on_travel_button_pressed() -> void:
	emit_signal("travel_selected", _item, _state_gui)
	_close()

func _on_stop_button_pressed() -> void:
	emit_signal("stop_selected", _item, _state_gui)
	_close()

func _on_perform_button_pressed() -> void:
	emit_signal("perform_selected", _item, _state_gui)
	_close()
