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
var action_guis: Array[ActionGui] = []


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
	action_guis.clear()
	
	# Now re-add everything
	for property in entity.properties:
		property_guis.append(PropertyGui.new(self, property))
	
	for variable in entity.variables:
		variable_guis.append(VariableGui.new(self, variable))

	for state in entity.states:
		var state_gui: StateGui = StateGui.new(self, state)
		state_guis.append(state_gui)
		action_guis.append_array(state_gui.action_guis)

#region: Properties

func get_property_names() -> Array[String]:
	return entity.get_property_names()

func _setup_properties_section(root: TreeItem) -> TreeItem:
	var properties: TreeItem = instruction_gui.create_item(root)
	properties.set_text(Column.TITLE, "Entity Properties")
	properties.add_button(Column.ADD_BUTTON, instruction_gui.plus_button_texture2d, EditType.ADD_PROPERTY, false, "Add Property")
	return properties

func _find_propertygui_by_treeitem(treeitem: TreeItem) -> PropertyGui:
	# Hopefully there are not too many properties
	var property_gui: PropertyGui = property_guis.filter(
		func(prop_gui: PropertyGui): return prop_gui.treeitem == treeitem
	).front()
	return property_gui

func _no_propertygui_with_propery_name(propery_name: String) -> bool:
	var properties: Array[PropertyGui] = property_guis.filter(
		func(prop_gui: PropertyGui):
			return prop_gui.property.property_name == propery_name
	)
	return properties.is_empty()

func get_property_name_by_treeitem(treeitem: TreeItem) -> String:
	return _find_propertygui_by_treeitem(treeitem).property.property_name

func add_property(property_name: String) -> void:
	if _no_propertygui_with_propery_name(property_name):
		var new_property: AIProperty = AIProperty.new(property_name)
		var new_property_gui: PropertyGui = PropertyGui.new(self, new_property)
		entity.properties.append(new_property)
		property_guis.append(new_property_gui)

func edit_property_by_treeitem(treeitem: TreeItem, property_name: String) -> void:
	if _no_propertygui_with_propery_name(property_name):
		var property_gui: PropertyGui = _find_propertygui_by_treeitem(treeitem)
		property_gui.property.property_name = property_name
		property_gui.treeitem.set_text(Column.TITLE, property_name)

func delete_property_by_treeitem(treeitem: TreeItem) -> void:
	var property_gui: PropertyGui = _find_propertygui_by_treeitem(treeitem)
	properties_treeitem.remove_child(property_gui.treeitem)
	entity.properties.erase(property_gui.property)
	property_guis.erase(property_gui)

#endregion

#region: Variables

func get_variable_names() -> Array[String]:
	return entity.get_variable_names()

func _setup_variables_section(root: TreeItem) -> TreeItem:
	var variables: TreeItem = instruction_gui.create_item(root)
	variables.set_text(Column.TITLE, "State Variables")
	variables.add_button(Column.ADD_BUTTON, instruction_gui.plus_button_texture2d, EditType.ADD_VARIABLE, false, "Add Variable")
	return variables

func _find_variablegui_by_treeitem(treeitem: TreeItem) -> VariableGui:
	# Hopefully there are not too many properties
	var variable_gui: VariableGui = variable_guis.filter(
		func(var_gui: VariableGui): return var_gui.treeitem == treeitem
	).front()
	return variable_gui

func _no_variablegui_with_variable_name(variable_name: String) -> bool:
	var variables: Array[VariableGui] = variable_guis.filter(
		func(var_gui: VariableGui):
			return var_gui.variable.variable_name == variable_name
	)
	return variables.is_empty()

func get_variable_name_by_treeitem(treeitem: TreeItem) -> String:
	return _find_variablegui_by_treeitem(treeitem).variable.variable_name

func add_variable(variable_name: String) -> void:
	if _no_variablegui_with_variable_name(variable_name):
		var new_variable: AIVariable = AIVariable.new(variable_name)
		var new_variable_gui: VariableGui = VariableGui.new(self, new_variable)
		entity.variables.append(new_variable)
		variable_guis.append(new_variable_gui)

func edit_variable_by_treeitem(treeitem: TreeItem, variable_name: String) -> void:
	if _no_variablegui_with_variable_name(variable_name):
		var variable_gui: VariableGui = _find_variablegui_by_treeitem(treeitem)
		variable_gui.variable.variable_name = variable_name
		variable_gui.treeitem.set_text(Column.TITLE, variable_name)

func delete_variable_by_treeitem(treeitem: TreeItem) -> void:
	var variable_gui: VariableGui = _find_variablegui_by_treeitem(treeitem)
	variables_treeitem.remove_child(variable_gui.treeitem)
	entity.variables.erase(variable_gui.variable)
	variable_guis.erase(variable_gui)

#endregion

#region: States

func _setup_states_section(root: TreeItem) -> TreeItem:
	var states: TreeItem = instruction_gui.create_item(root)
	states.set_text(Column.TITLE, "States")
	states.add_button(Column.ADD_BUTTON, instruction_gui.plus_button_texture2d, EditType.ADD_STATE, false, "Add State")
	return states

func find_stategui_by_treeitem(treeitem: TreeItem) -> StateGui:
	# Hopefully there are not too many properties
	var state_gui: StateGui = state_guis.filter(
		func(st_gui: StateGui): return st_gui.treeitem == treeitem
	).front()
	return state_gui

func _no_stategui_with_state_name(state_name: String) -> bool:
	var states: Array[StateGui] = state_guis.filter(
		func(st_gui: StateGui):
			return st_gui.state.state_name == state_name
	)
	return states.is_empty()

func get_state_name_by_treeitem(treeitem: TreeItem) -> String:
	return find_stategui_by_treeitem(treeitem).state.state_name

func add_state(state_name: String) -> void:
	if _no_stategui_with_state_name(state_name):
		var new_state: AIState = AIState.new(state_name)
		var new_state_gui: StateGui = StateGui.new(self, new_state)
		entity.states.append(new_state)
		state_guis.append(new_state_gui)
	
func edit_state_by_treeitem(treeitem: TreeItem, state_name: String) -> void:
	if _no_stategui_with_state_name(state_name):
		var state_gui: StateGui = find_stategui_by_treeitem(treeitem)
		state_gui.state.state_name = state_name
		state_gui.treeitem.set_text(Column.TITLE, state_name)

func delete_state_by_treeitem(treeitem: TreeItem) -> void:
	var state_gui: StateGui = find_stategui_by_treeitem(treeitem)
	states_treeitem.remove_child(state_gui.treeitem)
	entity.states.erase(state_gui.state)
	state_guis.erase(state_gui)

#endregion

#region actions

func _add_action_to_state(state_gui: StateGui, new_action: AIAction) -> void:
	var new_action_gui: ActionGui = ActionGui.get_gui_for_action(state_gui, new_action)
	state_gui.state.actions.append(new_action)
	state_gui.action_guis.append(new_action_gui)
	action_guis.append(new_action_gui)

func _find_actiongui_by_treeitem(treeitem: TreeItem) -> ActionGui:
	# Hopefully there are not too many actions
	var action_gui: ActionGui = action_guis.filter(
		func(action_gui: ActionGui): return action_gui.treeitem == treeitem
	).front()
	return action_gui

func get_action_name_by_treeitem(treeitem: TreeItem) -> String:
	var action_gui: ActionGui = _find_actiongui_by_treeitem(treeitem)
	return action_gui.action_text

func get_action_by_treeitem(treeitem: TreeItem) -> ActionGui:
	var action_gui: ActionGui = _find_actiongui_by_treeitem(treeitem)
	return action_gui

func add_assignment_to_state(state_gui: StateGui, variable_name: String, function_name: String, argument_names: Array[String]) -> void:
	var new_action: AIAction = AIAction.AIAssignment.new(variable_name, function_name, argument_names)
	_add_action_to_state(state_gui, new_action)

func add_travel_to_state(state_gui: StateGui, direction_variable_name: String, distance_variable_name: String) -> void:
	var new_action: AIAction = AIAction.AITravel.new(direction_variable_name, distance_variable_name)
	_add_action_to_state(state_gui, new_action)

func add_stop_to_state(state_gui: StateGui) -> void:
	var new_action: AIAction = AIAction.AIStop.new()
	_add_action_to_state(state_gui, new_action)

func add_perform_to_state(state_gui: StateGui, function_name: String, argument_names: Array[String]) -> void:
	var new_action: AIAction = AIAction.AIPerform.new(function_name, argument_names)
	_add_action_to_state(state_gui, new_action)

func edit_assignment_by_treeitem(
	treeitem: TreeItem,
	variable_name: String,
	function_name: String,
	argument_names: Array[String]
) -> void:
	var action_gui: ActionGui.AssignmentGui = _find_actiongui_by_treeitem(treeitem)
	action_gui.action.assign_variable_name = variable_name
	action_gui.action.function_name = function_name
	action_gui.action.function_argument_names = argument_names
	action_gui.update()
	action_gui.treeitem.set_text(Column.TITLE, action_gui.action_text)

func delete_action_by_treeitem(treeitem: TreeItem) -> void:
	var action_gui: ActionGui = _find_actiongui_by_treeitem(treeitem)
	var state_gui: StateGui = action_gui.state_gui
	
	state_gui.action_treeitem.remove_child(action_gui.treeitem)
	state_gui.state.actions.erase(action_gui.action)
	state_gui.action_guis.erase(action_gui)
	action_guis.erase(action_gui)

#endregion
