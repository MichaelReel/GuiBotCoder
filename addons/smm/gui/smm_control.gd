class_name SmmControl
extends Control

@onready var add_property_popup_panel: PopupPanel = $AddPropertyPopupPanel
@onready var add_variable_popup_panel: PopupPanel = $AddVariablePopupPanel
@onready var add_state_popup_panel: PopupPanel = $AddStatePopupPanel
@onready var add_action_popup_panel: PopupPanel = $AddActionPopupPanel
@onready var edit_property_popup_panel: PopupPanel = $EditPropertyPopupPanel
@onready var edit_variable_popup_panel: PopupPanel = $EditVariablePopupPanel
@onready var edit_state_popup_panel: PopupPanel = $EditStatePopupPanel
@onready var delete_property_popup_panel: PopupPanel = $DeletePropertyPopupPanel
@onready var delete_variable_popup_panel: PopupPanel = $DeleteVariablePopupPanel
@onready var delete_state_popup_panel: PopupPanel = $DeleteStatePopupPanel
@onready var file_dialog: FileDialog = $StateMachineFileDialog

@onready var window_list: Array[Window] = [
	add_property_popup_panel,
	add_variable_popup_panel,
	add_state_popup_panel,
	add_action_popup_panel,
	edit_property_popup_panel,
	edit_variable_popup_panel,
	edit_state_popup_panel,
	delete_property_popup_panel,
	delete_variable_popup_panel,
	delete_state_popup_panel,
	file_dialog,
]

func _ready() -> void:
	print("ssm_control _ready()")

func get_extra_windows() -> Array[Window]:
	return window_list
