extends PopupPanel

signal add_variable(variable_name: String)

@onready var variable_name_field: LineEdit = $VBoxContainer/VariableNameField

func _ready() -> void:
	_set_to_center()

func show_add() -> void:
	variable_name_field.grab_focus()
	show()

func _set_to_center() -> void:
	position = (DisplayServer.window_get_size() / 2) - (size / 2)

func _close() -> void:
	visible = false

func _on_add_button_pressed() -> void:
	if variable_name_field.text:
		emit_signal("add_variable", variable_name_field.text)
		variable_name_field.text = ""
		_close()

func _on_cancel_button_pressed() -> void:
	_close()
