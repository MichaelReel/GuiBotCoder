@tool
extends PopupPanel

signal assign_selected()
signal travel_selected()
signal stop_selected()
signal perform_selected()


func _ready() -> void:
	_set_to_center()

func show_add() -> void:
	show()

func _set_to_center() -> void:
	position = (DisplayServer.window_get_size() / 2) - (size / 2)

func _close() -> void:
	visible = false

func _on_cancel_button_pressed() -> void:
	_close()

func _on_assign_button_pressed() -> void:
	emit_signal("assign_selected")
	_close()

func _on_travel_button_pressed() -> void:
	emit_signal("travel_selected")
	_close()

func _on_stop_button_pressed() -> void:
	emit_signal("stop_selected")
	_close()

func _on_perform_button_pressed() -> void:
	emit_signal("perform_selected")
	_close()
