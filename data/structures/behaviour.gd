class_name AIBehaviour
extends Node

var behaviour_name: String
var gui_tree_item: TreeItem

var rules: Array[Rule] = []

class Rule:
	# TODO: These should really be dictionaries at source
	var _properties: Array[AIProperty]
	var _variables: Array[AIVariable]
	
	func _init(properties: Array[AIProperty], variables: Array[AIVariable]) -> void:
		_properties = properties
		_variables = variables

class MoveRelativeBehaviour extends Rule:
	var direction  # Need a direction variant, e.g.: Targetted, Random 
	var distance  # Variant, e.g: Rand Range, max distance

class MoveTargettedBehaviour extends Rule:
	var target
	var max_distance

class MoveCeaseBehaviour extends Rule:
	pass

class EntityCondition:
	pass

class EntityScan extends Rule:
	var scan_radius_property_name: String
	var entity_conditions: Array[EntityCondition]
	var assign_variable_name: String
	var state_transition_name: String

class EntityRange extends Rule:
	enum COMPARITOR {EQUAL, NOT_EQUAL, GREATER_THAN, LESS_THAN, GREATER_THAN_OR_EQUAL, LESS_THAN_OR_EQUAL}
	
	var entity_variable_name: String
	var range_property_name: String
	var comparitor: COMPARITOR
	var state_transition_name: String

