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
	properties_treeitem = _setup_properties_section(treeitem)
	variables_treeitem = _setup_variables_section(treeitem)
	states_treeitem = _setup_states_section(treeitem)
	self.entity = entity
	update()

func update() -> void:
	# Lets not get too complex until we get performance issues, just recreate all gui elements from scratch
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
