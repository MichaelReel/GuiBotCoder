class_name AIConditional
extends Object

var condition_function_name: String
var condition_argument_names: Array[String]

func _init(function: String, args: Array[String]) -> void:
	condition_function_name = function
	condition_argument_names = args
