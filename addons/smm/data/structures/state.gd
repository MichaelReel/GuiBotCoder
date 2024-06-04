class_name AIState
extends Object

var state_name: String

var actions: Array[AIAction] = []
var transistions: Array[AITransition] = []

func _init(name: String) -> void:
	state_name = name

func get_assigned_variable_names() -> Array[String]:
	var assigned_variable_names: Array[String]
	assigned_variable_names.assign(
		actions.filter(
			func (action: AIAction) -> bool: return action is AIAction.AIAssignment
		).map(
			func (action: AIAction) -> String: return action.assign_variable_name
		)
	)
	return assigned_variable_names
