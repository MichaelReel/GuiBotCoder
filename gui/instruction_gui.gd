extends Tree

@export var plus_button_texture2d: Texture2D

const ADD_ID: int = 1
const REMOVE_ID: int = 2

var _root: TreeItem

var _properties_gui: TreeItem
var _variables_gui: TreeItem
var _states_gui: TreeItem


func _ready() -> void:
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
	
	# Add sample variables
	_add_variable(_variables_gui, "Target")
	
	# Add sample states
	_add_state(_states_gui, "Wander")
	_add_state(_states_gui, "Approach Enemy")
	_add_state(_states_gui, "Melee Attack Enemy")
	
	# TODO: Create the GUI to back the datastructure (rather than the other way around)
	
	var entity: AIEntity = AIEntity.new()
	entity.gui_tree_item = _root
	for property_gui in _properties_gui.get_children():
		var property: AIProperty = AIProperty.new()
		property.gui_tree_item = (property_gui as TreeItem)
		property.property_name = (property_gui as TreeItem).get_text(0)
		entity.properties.append(property)
	
	for variable_gui in _variables_gui.get_children():
		var variable: AIVariable = AIVariable.new()
		variable.gui_tree_item = (variable_gui as TreeItem)
		variable.variable_name = (variable_gui as TreeItem).get_text(0)
		entity.variables.append(variable)
	
	for state_gui in _states_gui.get_children():
		var state: AIState = AIState.new()
		state.gui_tree_item = (state_gui as TreeItem)
		state.state_name = (state_gui as TreeItem).get_text(0)
		entity.states.append(state)
		
		# No behaviours added yet
	
	# Test Save
	var file_access: AIFileAccess = AIFileAccess.new()
	file_access.save_file(entity, "test_ai_entity.json")


func _setup_expected_properties_section(root: TreeItem) -> TreeItem:
	var properties: TreeItem = create_item(root)
	properties.set_text(0, "Entity Properties")
	properties.add_button(0, plus_button_texture2d, ADD_ID, false, "Add Property")
	
	return properties


func _setup_variables_section(root: TreeItem) -> TreeItem:
	var variables: TreeItem = create_item(root)
	variables.set_text(0, "State Variables")
	variables.add_button(0, plus_button_texture2d, ADD_ID, false, "Add Variable")
	
	return variables


func _setup_states(root: TreeItem) -> TreeItem:
	var states: TreeItem = create_item(root)
	states.set_text(0, "States")
	states.add_button(0, plus_button_texture2d, ADD_ID, false, "Add State")
	
	return states


func _add_property(properties: TreeItem, property_name: String) -> void:
	var property: TreeItem = create_item(properties)
	property.set_text(0, property_name)


func _add_variable(variables: TreeItem, variable_name: String) -> void:
	var variable: TreeItem = create_item(variables)
	variable.set_text(0, variable_name)


func _add_state(states: TreeItem, state_name: String) -> TreeItem:
	var state: TreeItem = create_item(states)
	state.set_text(0, state_name)
	state.add_button(0, plus_button_texture2d, ADD_ID, false, "Add Behaviour")
	return state
	

	#
	#_generate_sample_rules()
#
#
#func _generate_sample_rules() -> void:
	#"""Spiking out how the interface could look"""
	#_states = create_item()
	#_states.set_text(0, "States")
	#_states.add_button(0, plus_button_texture2d, ADD_ID, false, "Add State")
	#
	#_generate_wander_state(_states)
	#_generate_approach_entity_state(_states)
#
#func _generate_wander_state(states: TreeItem) -> void:
	#var wander_state: TreeItem = create_item(states)
	#wander_state.set_text(0, "State Name: Wander")
	#
	#_generate_random_move_behaviour(wander_state)
	#_generate_enemy_scan_behaviour(wander_state)
#
#func _generate_random_move_behaviour(state: TreeItem) -> void:
	#var move: TreeItem = create_item(state)
	#move.set_text(0, "Movement Behaviour: Relative")
	#var direction: TreeItem = create_item(move)
	#var distance: TreeItem = create_item(move)
	#direction.set_text(0, "Direction: Any")
	#distance.set_text(0, "Distance: Any")
#
#
#func _generate_enemy_scan_behaviour(state: TreeItem) -> void:
	#var scan_behaviour: TreeItem = create_item(state)
	#scan_behaviour.set_text(0, "Scan Behaviour for Any: Entity")
	#_add_scan_modifier("Entity Type", "Enemy", scan_behaviour)
	#_add_scan_modifier("Entity Level less than", "5", scan_behaviour)
	#var result_state: TreeItem = create_item(scan_behaviour)
	#result_state.set_text(0, "State Transistion: Approach Enemy (Entity)")
#
#
#func _generate_approach_entity_state(states: TreeItem) -> void:
	#var approach_state: TreeItem = create_item(states)
	#approach_state.set_text(0, "State Name: Approach Enemy (Entity)")
	#
	#_generate_target_move_behaviour(approach_state)
	#_generate_enemy_approach_scan_behaviour(approach_state)
#
#
#func _generate_target_move_behaviour(state: TreeItem) -> void:
	#var move: TreeItem = create_item(state)
	#move.set_text(0, "Movement Behaviour: Targeted")
	#var direction: TreeItem = create_item(move)
	#direction.set_text(0, "Direction: Entity")
#
#
#func _generate_enemy_approach_scan_behaviour(state: TreeItem) -> void:
	#var scan_behaviour: TreeItem = create_item(state)
	#scan_behaviour.set_text(0, "Scan Behaviour: Entity")
	#_add_scan_modifier("Distance to (Entity) less than", "Melee Range", scan_behaviour)
	#var result_state: TreeItem = create_item(scan_behaviour)
	#result_state.set_text(0, "State Transistion: Approach (Entity)")
#
#
#func _add_scan_modifier(mod_name: String, mod_value: String, scan: TreeItem) -> void:
	#var scan_mod: TreeItem = create_item(scan)
	#scan_mod.set_text(0, mod_name + ": " + mod_value)


func _on_button_clicked(item: TreeItem, _column: int, id: int, _mouse_button_index: int) -> void:
	if id == ADD_ID:
		match item:
			_properties_gui:
				print("add property")
			_variables_gui:
				print("add variable")
			_states_gui:
				print("add state")
