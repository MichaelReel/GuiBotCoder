class_name InstructionGui
extends Tree

@export var plus_button_texture2d: Texture2D
@export var minus_button_texture2d: Texture2D
@export var modify_button_texture2d: Texture2D

var root: EntityGui

@onready var add_property_popup_panel: PopupPanel = $AddPropertyPopupPanel

func _ready() -> void:
	set_column_expand(Column.TITLE, true)
	set_column_expand(Column.ADD_BUTTON, false)
	set_column_expand(Column.REMOVE_BUTTON, false)
	set_column_expand(Column.EDIT_BUTTON, false)
	set_column_custom_minimum_width(Column.ADD_BUTTON, plus_button_texture2d.get_width())
	set_column_custom_minimum_width(Column.REMOVE_BUTTON, minus_button_texture2d.get_width())
	set_column_custom_minimum_width(Column.EDIT_BUTTON, modify_button_texture2d.get_width())
	
	# Test Load
	var file_access: AIFileAccess = AIFileAccess.new()
	var entity: AIEntity = file_access.load_file("test_ai_entity.json")
	
	hide_root = true
	root = EntityGui.new(self, entity)
	
	# Save back to test file to see changes in git diff
	file_access.save_file(entity, "test_ai_entity.json")

func _on_button_clicked(item: TreeItem, _column: int, id: int, _mouse_button_index: int) -> void:
	match id:
		EditType.ADD_PROPERTY:
			print("ADD_PROPERTY: ", str(item))
			add_property_popup_panel.visible = true
		EditType.ADD_VARIABLE:
			print("ADD_VARIABLE: ", str(item))
		EditType.ADD_STATE:
			print("ADD_STATE: ", str(item))
		EditType.ADD_ACTION:
			print("ADD_ACTION: ", str(item))
		EditType.ADD_TRANSISTION:
			print("ADD_TRANSISTION: ", str(item))
		EditType.ADD_CONDITION:
			print("ADD_CONDITION: ", str(item))
		EditType.REMOVE_PROPERTY:
			print("REMOVE_PROPERTY: ", str(item))
		EditType.REMOVE_VARIABLE:
			print("REMOVE_VARIABLE: ", str(item))
		EditType.REMOVE_STATE:
			print("REMOVE_STATE: ", str(item))
		EditType.REMOVE_ACTION:
			print("REMOVE_ACTION: ", str(item))
		EditType.REMOVE_TRANSISTION:
			print("REMOVE_TRANSISTION: ", str(item))
		EditType.REMOVE_CONDITION:
			print("REMOVE_CONDITION: ", str(item))
		EditType.EDIT_PROPERTY:
			print("EDIT_PROPERTY: ", str(item))
		EditType.EDIT_VARIABLE:
			print("EDIT_VARIABLE: ", str(item))
		EditType.EDIT_STATE:
			print("EDIT_STATE: ", str(item))
		EditType.EDIT_ACTION:
			print("EDIT_ACTION: ", str(item))
		EditType.EDIT_TRANSISTION:
			print("EDIT_TRANSISTION: ", str(item))
		EditType.EDIT_CONDITION:
			print("EDIT_CONDITION: ", str(item))

func _get_random_direction() -> Vector2:
	return Vector2.from_angle(randf_range(0, PI * 2.0))
