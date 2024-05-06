class_name AIAction
extends Object

class AIAssignment extends AIAction:
	var assign_variable_name: String
	var function_name: String
	var function_argument_names: Array[String]
	
	func _init(variable_name: String, function: String, args: Array[String]) -> void:
		assign_variable_name = variable_name
		function_name = function
		function_argument_names = args

class AITravel extends AIAction:
	var direction_variable_name: String
	var distance_variable_name: String
	
	func _init(direction: String, distance: String) -> void:
		direction_variable_name = direction
		distance_variable_name = distance

class AIStop extends AIAction:
	pass

class AIPerform extends AIAction:
	var function_name: String
	var function_argument_names: Array[String]
	
	func _init(function: String, args: Array[String]) -> void:
		function_name = function
		function_argument_names = args
	
