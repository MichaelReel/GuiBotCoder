class_name EntityGui
extends Object

var instruction_gui: InstructionGui
var entity: AIEntity
var treeitem: TreeItem
var properties_treeitem: TreeItem
var variables_treeitem: TreeItem
var states_treeitem: TreeItem

var property_guis: Array[PropertyGui] = []
var variable_guis: Array[VariableGui] = []
var state_guis: Array[StateGui] = []


func _init(instruction_gui_: Tree, entity: AIEntity) -> void:
	instruction_gui = instruction_gui_
	treeitem = instruction_gui.create_item()
	self.entity = entity
	update()

func update() -> void:
	# Lets not get too complex until we get performance issues, just recreate all gui elements from scratch
	if properties_treeitem: treeitem.remove_child(properties_treeitem)
	if variables_treeitem: treeitem.remove_child(variables_treeitem)
	if states_treeitem: treeitem.remove_child(states_treeitem)
	
	properties_treeitem = _setup_properties_section(treeitem)
	variables_treeitem = _setup_variables_section(treeitem)
	states_treeitem = _setup_states_section(treeitem)
	
	property_guis.clear()
	variable_guis.clear()
	state_guis.clear()
	
	# Now re-add everything
	for property in entity.properties:
		property_guis.append(PropertyGui.new(self, property))
	
	for variable in entity.variables:
		variable_guis.append(VariableGui.new(self, variable))

	for state in entity.states:
		state_guis.append(StateGui.new(self, state))

func find_propertygui_by_treeitem(treeitem: TreeItem) -> PropertyGui:
	# Hopefully there are not too many properties
	var property_gui: PropertyGui = property_guis.filter(
		func(prop_gui: PropertyGui): return prop_gui.treeitem == treeitem
	).front()
	return property_gui

func no_propertygui_with_propery_name(propery_name: String) -> bool:
	var properties: Array[PropertyGui] = property_guis.filter(
		func(prop_gui: PropertyGui):
			return prop_gui.property.property_name == propery_name
	)
	return properties.is_empty()
	

func get_property_name_by_treeitem(treeitem: TreeItem) -> String:
	return find_propertygui_by_treeitem(treeitem).property.property_name

func add_property(property_name: String) -> void:
	if no_propertygui_with_propery_name(property_name):
		var new_property: AIProperty = AIProperty.new(property_name)
		var new_property_gui: PropertyGui = PropertyGui.new(self, new_property)
		property_guis.append(new_property_gui)

func delete_property_by_treeitem(treeitem: TreeItem) -> void:
	var property_gui: PropertyGui = find_propertygui_by_treeitem(treeitem)
	properties_treeitem.remove_child(property_gui.treeitem)
	entity.properties.erase(property_gui.property)

func edit_property_by_treeitem(treeitem: TreeItem, property_name: String) -> void:
	var property_gui: PropertyGui = find_propertygui_by_treeitem(treeitem)
	property_gui.property.property_name = property_name
	property_gui.treeitem.set_text(Column.TITLE, property_name)

func _setup_properties_section(root: TreeItem) -> TreeItem:
	var properties: TreeItem = instruction_gui.create_item(root)
	properties.set_text(Column.TITLE, "Entity Properties")
	properties.add_button(Column.ADD_BUTTON, instruction_gui.plus_button_texture2d, EditType.ADD_PROPERTY, false, "Add Property")
	
	return properties

func _setup_variables_section(root: TreeItem) -> TreeItem:
	var variables: TreeItem = instruction_gui.create_item(root)
	variables.set_text(Column.TITLE, "State Variables")
	variables.add_button(Column.ADD_BUTTON, instruction_gui.plus_button_texture2d, EditType.ADD_VARIABLE, false, "Add Variable")
	
	return variables

func _setup_states_section(root: TreeItem) -> TreeItem:
	var states: TreeItem = instruction_gui.create_item(root)
	states.set_text(Column.TITLE, "States")
	states.add_button(Column.ADD_BUTTON, instruction_gui.plus_button_texture2d, EditType.ADD_STATE, false, "Add State")
	
	return states
