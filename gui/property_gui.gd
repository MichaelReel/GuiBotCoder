class_name PropertyGui
extends Object

var entity_gui: EntityGui
var property: AIProperty
var treeitem: TreeItem

func _init(entity_gui_: EntityGui, property: AIProperty) -> void:
	entity_gui = entity_gui_
	var tree = entity_gui.treeitem.get_tree()
	treeitem = tree.create_item(entity_gui.properties_treeitem)
	self.property = property
	update()

func update() -> void:
	# Make sure the GUI matches the elements in the property
	treeitem.set_text(Column.TITLE, property.property_name)
	treeitem.add_button(Column.EDIT_BUTTON, entity_gui.instruction_gui.modify_button_texture2d, EditType.EDIT_PROPERTY, false, "Edit Property")
	treeitem.add_button(Column.REMOVE_BUTTON, entity_gui.instruction_gui.minus_button_texture2d, EditType.REMOVE_PROPERTY, false, "Remove Property")
