class_name AITransition
extends Object

var target_state_name: String
var conditionals: Array[AIConditional] = []

func _init(name: String) -> void:
	target_state_name = name
