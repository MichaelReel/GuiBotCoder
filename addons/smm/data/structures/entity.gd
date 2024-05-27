class_name AIEntity
extends Object

var entity_name: String = "New Entity"
var properties: Array[AIProperty] = []
var variables: Array[AIVariable] = []
var states: Array[AIState] = []

func _init(name: String) -> void:
	entity_name = name
