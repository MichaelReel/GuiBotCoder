class_name VariableGui
extends Object

var entity_gui: EntityGui
var variable: AIVariable
var treeitem: TreeItem

func _init(entity_gui_: EntityGui, variable: AIVariable) -> void:
	entity_gui = entity_gui_
	var tree = entity_gui.treeitem.get_tree()
	treeitem = tree.create_item(entity_gui.variables_treeitem)
	self.variable = variable
	update()

func update() -> void:
	# Make sure the GUI matches the elements in the variable
	treeitem.set_text(Column.TITLE, variable.variable_name)
	treeitem.add_button(Column.REMOVE_BUTTON, entity_gui.instruction_gui.minus_button_texture2d, EditType.REMOVE_PROPERTY, false, "Remove Variable")
