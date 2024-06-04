class_name AIEntity
extends Object

var entity_name: String = "New Entity"
var properties: Array[AIProperty] = []
var variables: Array[AIVariable] = []
var states: Array[AIState] = []

func _init(name: String) -> void:
	entity_name = name

func  get_property_names() -> Array[String]:
	var property_names: Array[String]
	property_names.assign(
		properties.map(func (property: AIProperty) -> String: return property.property_name)
	)
	return property_names

func get_variable_names() -> Array[String]:
	var variable_names: Array[String]
	variable_names.assign(
		variables.map(func (variable: AIVariable) -> String: return variable.variable_name)
	)
	return variable_names
