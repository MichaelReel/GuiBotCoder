class_name AIState
extends Object

var state_name: String

var actions: Array[AIAction] = []
var transistions: Array[AITransition] = []

func _init(name: String) -> void:
	state_name = name
