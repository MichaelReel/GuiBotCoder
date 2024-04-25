extends Tree

@export var plus_button_texture2d: Texture2D
@export var minus_button_texture2d: Texture2D
@export var modify_button_texture2d: Texture2D

enum EditType {
	ADD_PROPERTY,
	ADD_VARIABLE,
	ADD_STATE,
	ADD_BEHAVIOUR,
	REMOVE_PROPERTY,
	REMOVE_VARIABLE,
	REMOVE_STATE,
	REMOVE_BEHAVIOUR,
	EDIT_BEHAVIOUR,
}

enum Column {
	TITLE,
	ADD_BUTTON,
	REMOVE_BUTTON,
	EDIT_BUTTON,
}

var _root: TreeItem

var _properties_gui: TreeItem
var _variables_gui: TreeItem
var _states_gui: TreeItem


func _ready() -> void:
	set_column_expand(Column.TITLE, true)
	set_column_expand(Column.ADD_BUTTON, false)
	set_column_expand(Column.REMOVE_BUTTON, false)
	set_column_expand(Column.EDIT_BUTTON, false)
	set_column_custom_minimum_width(Column.ADD_BUTTON, plus_button_texture2d.get_width())
	set_column_custom_minimum_width(Column.REMOVE_BUTTON, minus_button_texture2d.get_width())
	set_column_custom_minimum_width(Column.EDIT_BUTTON, modify_button_texture2d.get_width())
	
	hide_root=true
	_root = create_item()
	
	_properties_gui = _setup_expected_properties_section(_root)
	_variables_gui = _setup_variables_section(_root)
	_states_gui = _setup_states(_root)
	
	# TODO: Move all the config to loading from a file
	
	# Add sample properties
	_add_property(_properties_gui, "Min Movement")
	_add_property(_properties_gui, "Max Movement")
	_add_property(_properties_gui, "Scan Range")
	_add_property(_properties_gui, "Melee Range")
	
	# Add sample variables
	_add_variable(_variables_gui, "Target")
	
	# Add sample states
	var wander_state: TreeItem = _add_state(_states_gui, "Wander")
	var approach_enemy_state: TreeItem = _add_state(_states_gui, "Approach Enemy")
	var melee_attack_enemy_state: TreeItem = _add_state(_states_gui, "Melee Attack Enemy")
	
	# Add sample behaviours
	var _wander_movement_behaviour: TreeItem = _add_movement_relative_behaviour(wander_state, "Any", "Min Movement", "Max Movement")
	var _wander_scan_behaviour: TreeItem = _add_scanning_area_le_level_behaviour(wander_state, "Scan Range", "Enemy", 5, "Target", "Approach Enemy")
	
	var _approach_movement_behaviour: TreeItem = _add_movement_to_entity_behaviour(approach_enemy_state, "Target", "Max Movement")
	var _approach_scan_le_behavour: TreeItem = _add_scanning_entity_distance_le_behaviour(approach_enemy_state, "Target", "Melee Range", "Melee Attack Enemy")
	var _approach_scan_gt_behavour: TreeItem = _add_scanning_entity_distance_gt_behaviour(approach_enemy_state, "Target", "Scan Range", "Wander")
	
	var _melee_movement_behaviour: TreeItem = _add_movement_stop_behaviour(melee_attack_enemy_state)
	var _melee_scan_gt_behaviour: TreeItem = _add_scanning_entity_distance_gt_behaviour(melee_attack_enemy_state, "Target", "Melee Range", "Approach Enemy")
	var _melee_attack_behaviour: TreeItem = _add_entity_melee_attack_behaviour(melee_attack_enemy_state, "Target")
	
	# TODO: Create the GUI to back the datastructure (rather than the other way around)
	
	var entity: AIEntity = AIEntity.new()
	entity.gui_tree_item = _root
	for property_gui in _properties_gui.get_children():
		var property: AIProperty = AIProperty.new()
		property.gui_tree_item = (property_gui as TreeItem)
		property.property_name = property.gui_tree_item.get_text(0)
		entity.properties.append(property)
	
	for variable_gui in _variables_gui.get_children():
		var variable: AIVariable = AIVariable.new()
		variable.gui_tree_item = (variable_gui as TreeItem)
		variable.variable_name = variable.gui_tree_item.get_text(0)
		entity.variables.append(variable)
	
	for state_gui in _states_gui.get_children():
		var state: AIState = AIState.new()
		state.gui_tree_item = (state_gui as TreeItem)
		state.state_name = state.gui_tree_item.get_text(0)
		entity.states.append(state)
		
		# No behaviours added yet
		for behaviour_gui in state_gui.get_children():
			var behaviour: AIBehaviour = AIBehaviour.new()
			behaviour.gui_tree_item = (behaviour_gui as TreeItem)
			behaviour.behaviour_name = behaviour.gui_tree_item.get_text(0)
			state.behaviours.append(behaviour)
	
	# Test Save
	var file_access: AIFileAccess = AIFileAccess.new()
	file_access.save_file(entity, "test_ai_entity.json")


func _setup_expected_properties_section(root: TreeItem) -> TreeItem:
	var properties: TreeItem = create_item(root)
	properties.set_text(Column.TITLE, "Entity Properties")
	properties.add_button(Column.ADD_BUTTON, plus_button_texture2d, EditType.ADD_PROPERTY, false, "Add Property")
	
	return properties


func _setup_variables_section(root: TreeItem) -> TreeItem:
	var variables: TreeItem = create_item(root)
	variables.set_text(Column.TITLE, "State Variables")
	variables.add_button(Column.ADD_BUTTON, plus_button_texture2d, EditType.ADD_VARIABLE, false, "Add Variable")
	
	return variables


func _setup_states(root: TreeItem) -> TreeItem:
	var states: TreeItem = create_item(root)
	states.set_text(Column.TITLE, "States")
	states.add_button(Column.ADD_BUTTON, plus_button_texture2d, EditType.ADD_STATE, false, "Add State")
	
	return states


func _add_property(properties: TreeItem, property_name: String) -> void:
	var property: TreeItem = create_item(properties)
	property.set_text(Column.TITLE, property_name)
	property.add_button(Column.REMOVE_BUTTON, minus_button_texture2d, EditType.REMOVE_PROPERTY, false, "Remove Property")


func _add_variable(variables: TreeItem, variable_name: String) -> void:
	var variable: TreeItem = create_item(variables)
	variable.set_text(Column.TITLE, variable_name)
	variable.add_button(Column.REMOVE_BUTTON, minus_button_texture2d, EditType.REMOVE_VARIABLE, false, "Remove Variable")


func _add_state(states: TreeItem, state_name: String) -> TreeItem:
	var state: TreeItem = create_item(states)
	state.set_text(Column.TITLE, state_name)
	state.add_button(Column.REMOVE_BUTTON, minus_button_texture2d, EditType.REMOVE_STATE, false, "Remove State")
	state.add_button(Column.ADD_BUTTON, plus_button_texture2d, EditType.ADD_BEHAVIOUR, false, "Add Behaviour")
	return state


# Behaviours should have:
	# Variable Assigns - Store some primitive or pointer to a node
	# State actions - Things that happen while we're in the current state
	# State changes - Changes to state
	#     with conditions - Rules that need to be met to enact a state change


func _add_movement_relative_behaviour(state: TreeItem, direction: String, min_property: String, max_property: String) -> TreeItem:
	var behaviour: TreeItem = create_item(state)
	behaviour.set_text(Column.TITLE, "Behaviour: Movement: Relative")
	behaviour.add_button(Column.REMOVE_BUTTON, minus_button_texture2d, EditType.REMOVE_BEHAVIOUR, false, "Remove Behaviour")
	behaviour.add_button(Column.EDIT_BUTTON, modify_button_texture2d, EditType.EDIT_BEHAVIOUR, false, "Edit Behaviour")
	
	var direction_argument: TreeItem = create_item(behaviour)
	direction_argument.set_text(Column.TITLE, "Direction: " + direction)
	var distance_range_argument: TreeItem = create_item(behaviour)
	distance_range_argument.set_text(Column.TITLE, "Distance: Range(" + min_property + " to " + max_property + ")")
	
	return behaviour


func _add_scanning_area_le_level_behaviour(
	state: TreeItem,
	radius_property: String,
	entity_type: String,
	less_or_equal_level: int,
	assign_variable: String,
	next_state: String
) -> TreeItem:
	var behaviour: TreeItem = create_item(state)
	behaviour.set_text(Column.TITLE, "Behaviour: Scan for Any")
	behaviour.add_button(Column.REMOVE_BUTTON, minus_button_texture2d, EditType.REMOVE_BEHAVIOUR, false, "Remove Behaviour")
	behaviour.add_button(Column.EDIT_BUTTON, modify_button_texture2d, EditType.EDIT_BEHAVIOUR, false, "Edit Behaviour")
	
	var radius_property_argument: TreeItem = create_item(behaviour)
	radius_property_argument.set_text(Column.TITLE, "Radius: " + radius_property)
	var entity_type_argument: TreeItem = create_item(behaviour)
	entity_type_argument.set_text(Column.TITLE, "Entity Type: " + entity_type)
	var entity_le_level_argument: TreeItem = create_item(behaviour)
	entity_le_level_argument.set_text(Column.TITLE, "Entity Level less than or equal to: " + str(less_or_equal_level))
	var assign_to_variable_argument: TreeItem = create_item(behaviour)
	assign_to_variable_argument.set_text(Column.TITLE, "Assign to: " + assign_variable)
	var state_transition_argument: TreeItem = create_item(behaviour)
	state_transition_argument.set_text(Column.TITLE, "State Transition: " + next_state)
	
	return behaviour


func _add_movement_to_entity_behaviour(state: TreeItem, entity_variable: String, velocity_property: String) -> TreeItem:
	var behaviour: TreeItem = create_item(state)
	behaviour.set_text(Column.TITLE, "Behaviour: Movement to Entity")
	behaviour.add_button(Column.REMOVE_BUTTON, minus_button_texture2d, EditType.REMOVE_BEHAVIOUR, false, "Remove Behaviour")
	behaviour.add_button(Column.EDIT_BUTTON, modify_button_texture2d, EditType.EDIT_BEHAVIOUR, false, "Edit Behaviour")
	
	var entity_variable_argument: TreeItem = create_item(behaviour)
	entity_variable_argument.set_text(Column.TITLE, "Entity: " + entity_variable)
	var velocity_property_argument: TreeItem = create_item(behaviour)
	velocity_property_argument.set_text(Column.TITLE, "Velocity: " + velocity_property)
	
	return behaviour


func _add_scanning_entity_distance_le_behaviour(state: TreeItem, entity_variable: String, range_property: String, next_state: String) -> TreeItem:
	var behaviour: TreeItem = create_item(state)
	behaviour.set_text(Column.TITLE, "Behaviour: Scan for Entity")
	behaviour.add_button(Column.REMOVE_BUTTON, minus_button_texture2d, EditType.REMOVE_BEHAVIOUR, false, "Remove Behaviour")
	behaviour.add_button(Column.EDIT_BUTTON, modify_button_texture2d, EditType.EDIT_BEHAVIOUR, false, "Edit Behaviour")
	
	var entity_variable_argument: TreeItem = create_item(behaviour)
	entity_variable_argument.set_text(Column.TITLE, "Entity: " + entity_variable)
	var range_property_argument: TreeItem = create_item(behaviour)
	range_property_argument.set_text(Column.TITLE, "Distance to Entity less than or equal to: " + range_property)
	var state_transition_argument: TreeItem = create_item(behaviour)
	state_transition_argument.set_text(Column.TITLE, "State Transition: " + next_state)
	
	return behaviour


func _add_scanning_entity_distance_gt_behaviour(state: TreeItem, entity_variable: String, range_property: String, next_state: String) -> TreeItem:
	var behaviour: TreeItem = create_item(state)
	behaviour.set_text(Column.TITLE, "Behaviour: Scan for Entity")
	behaviour.add_button(Column.REMOVE_BUTTON, minus_button_texture2d, EditType.REMOVE_BEHAVIOUR, false, "Remove Behaviour")
	behaviour.add_button(Column.EDIT_BUTTON, modify_button_texture2d, EditType.EDIT_BEHAVIOUR, false, "Edit Behaviour")
	
	var entity_variable_argument: TreeItem = create_item(behaviour)
	entity_variable_argument.set_text(Column.TITLE, "Entity: " + entity_variable)
	var range_property_argument: TreeItem = create_item(behaviour)
	range_property_argument.set_text(Column.TITLE, "Distance to Entity greater than: " + range_property)
	var state_transition_argument: TreeItem = create_item(behaviour)
	state_transition_argument.set_text(Column.TITLE, "State Transition: " + next_state)
	
	return behaviour


func _add_movement_stop_behaviour(state: TreeItem) -> TreeItem:
	var behaviour: TreeItem = create_item(state)
	behaviour.set_text(Column.TITLE, "Behaviour: Movement: Stop")
	behaviour.add_button(Column.REMOVE_BUTTON, minus_button_texture2d, EditType.REMOVE_BEHAVIOUR, false, "Remove Behaviour")
	
	return behaviour


func _add_entity_melee_attack_behaviour(state: TreeItem, entity_variable: String) -> TreeItem:
	var behaviour: TreeItem = create_item(state)
	behaviour.set_text(Column.TITLE, "Behaviour: Attack Entity")
	behaviour.add_button(Column.REMOVE_BUTTON, minus_button_texture2d, EditType.REMOVE_BEHAVIOUR, false, "Remove Behaviour")
	behaviour.add_button(Column.EDIT_BUTTON, modify_button_texture2d, EditType.EDIT_BEHAVIOUR, false, "Edit Behaviour")
	
	var entity_variable_argument: TreeItem = create_item(behaviour)
	entity_variable_argument.set_text(Column.TITLE, "Entity: " + entity_variable)
	
	return behaviour


func _on_button_clicked(_item: TreeItem, _column: int, id: int, _mouse_button_index: int) -> void:
	match id:
		EditType.ADD_PROPERTY:
			print("add property")
		EditType.ADD_VARIABLE:
			print("add variable")
		EditType.ADD_STATE:
			print("add state")
		EditType.ADD_BEHAVIOUR:
			print("add behaviour")
		EditType.REMOVE_PROPERTY:
			print("remove property")
		EditType.REMOVE_VARIABLE:
			print("remove variable")
		EditType.REMOVE_STATE:
			print("remove state")
		EditType.REMOVE_BEHAVIOUR:
			print("remove behaviour")
		EditType.EDIT_BEHAVIOUR:
			print("edit behaviour")


func _get_random_direction() -> Vector2:
	return Vector2.from_angle(randf_range(0, PI * 2.0))
