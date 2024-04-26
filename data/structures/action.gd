class_name AIAction
extends Object

class AIAssignment extends AIAction:
	var assign_variable_name: String
	var function_name: String
	var function_argument_names: Array[String]

class AITravel extends AIAction:
	var direction_variable_name: String
	var distance_variable_name: String

class AIStop extends AIAction:
	pass
