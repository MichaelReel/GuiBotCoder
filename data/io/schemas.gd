class_name AISchemas
extends RefCounted

const SCHEMA_VERSION: String = "0.01"

var AIEntitySchema: EntitySchema = EntitySchema.new(self)
var AIPropertySchema: PropertySchema = PropertySchema.new(self)
var AIVariableSchema: VariablesSchema = VariablesSchema.new(self)
var AIStateSchema: StateSchema = StateSchema.new(self)
var AIActionSchema: ActionSchema = ActionSchema.new(self)
var AITransitionSchema: TransitionSchema = TransitionSchema.new(self)
var AIConditionalSchema: ConditionalSchema = ConditionalSchema.new(self)


class SchemaBase extends RefCounted:
	var _schemas: AISchemas
	
	func _init(schema_root: AISchemas) -> void:
		_schemas = schema_root


class EntitySchema extends SchemaBase:
	func to_dict(entity: AIEntity) -> Dictionary:
		return {
			"version": SCHEMA_VERSION,
			"entity_name": entity.entity_name,
			"properties": entity.properties.map(_schemas.AIPropertySchema.to_dict),
			"variables": entity.variables.map(_schemas.AIVariableSchema.to_dict),
			"states": entity.states.map(_schemas.AIStateSchema.to_dict),
		}
	
	func to_domain(json: Dictionary) -> AIEntity:
		# Check version
		if json["version"] != SCHEMA_VERSION:
			printerr("version should be: " + SCHEMA_VERSION + ". File version is: " + json["version"])
			return AIEntity.new("Unloadable Entity")
		
		var entity = AIEntity.new(json["entity_name"])
		entity.properties.append_array(json["properties"].map(_schemas.AIPropertySchema.to_domain))
		entity.variables.append_array(json["variables"].map(_schemas.AIVariableSchema.to_domain))
		entity.states.append_array(json["states"].map(_schemas.AIStateSchema.to_domain))
		return entity


class PropertySchema extends SchemaBase:
	func to_dict(property: AIProperty) -> Dictionary:
		return {
			"property_name": property.property_name,
		}
	
	func to_domain(json: Dictionary) -> AIProperty:
		return AIProperty.new(json["property_name"])


class VariablesSchema extends SchemaBase:
	func to_dict(variable: AIVariable) -> Dictionary:
		return {
			"variable_name": variable.variable_name,
		}
	
	func to_domain(json: Dictionary) -> AIVariable:
		return AIVariable.new(json["variable_name"])


class StateSchema extends SchemaBase:
	func to_dict(state: AIState) -> Dictionary:
		return {
			"state_name": state.state_name,
			"actions": state.actions.map(_schemas.AIActionSchema.to_dict),
			"transitions": state.transistions.map(_schemas.AITransitionSchema.to_dict)
		}
	
	func to_domain(json: Dictionary) -> AIState:
		var state: AIState = AIState.new(json["state_name"])
		state.actions.append_array(json["actions"].map(_schemas.AIActionSchema.to_domain))
		state.transistions.append_array(json["transitions"].map(_schemas.AITransitionSchema.to_domain))
		return state


class ActionSchema extends SchemaBase:
	func to_dict(action: AIAction) -> Dictionary:
		if action is AIAction.AIAssignment:
			return _to_assignment_dict(action)
		if action is AIAction.AITravel:
			return _to_travel_dict(action)
		if action is AIAction.AIStop:
			return _to_stop_dict(action)
		if action is AIAction.AIPerform:
			return _to_perform_dict(action)
		return {"action_type": "unknown"}
	
	func to_domain(json: Dictionary) -> AIAction:
		match json["action_type"]:
			"assignment":
				return _to_assignment_domain(json)
			"travel":
				return _to_travel_domain(json)
			"stop":
				return _to_stop_domain(json)
			"perform":
				return _to_perform_domain(json)
		
		return AIAction.new()
	
	func _to_assignment_dict(action: AIAction.AIAssignment) -> Dictionary:
		return {
			"action_type": "assignment",
			"assign_variable_name": action.assign_variable_name,
			"function_name": action.function_name,
			"function_argument_names": action.function_argument_names,
		}
	
	func _to_assignment_domain(json: Dictionary) -> AIAction.AIAssignment:
		var function_argument_names: Array[String] = []
		function_argument_names.append_array(json["function_argument_names"])
		return AIAction.AIAssignment.new(
			json["assign_variable_name"],
			json["function_name"],
			function_argument_names,
		)
	
	func _to_travel_dict(action: AIAction.AITravel) -> Dictionary:
		return {
			"action_type": "travel",
			"direction_variable_name": action.direction_variable_name,
			"distance_variable_name": action.distance_variable_name,
		}
	
	func _to_travel_domain(json: Dictionary) -> AIAction.AITravel:
		return AIAction.AITravel.new(
			json["direction_variable_name"],
			json["distance_variable_name"],
		)
	
	func _to_stop_dict(_action: AIAction.AIStop) -> Dictionary:
		return {
			"action_type": "stop"
		}
	
	func _to_stop_domain(_json: Dictionary) -> AIAction.AIStop:
		return AIAction.AIStop.new()
	
	func _to_perform_dict(action: AIAction.AIPerform) -> Dictionary:
		return {
			"action_type": "perform",
			"function_name": action.function_name,
			"function_argument_names": action.function_argument_names,
		}
	
	func _to_perform_domain(json: Dictionary) -> AIAction.AIPerform:
		var function_argument_names: Array[String] = []
		function_argument_names.append_array(json["function_argument_names"])
		return AIAction.AIPerform.new(
			json["function_name"],
			function_argument_names,
		)


class TransitionSchema extends SchemaBase:
	func to_dict(transition: AITransition) -> Dictionary:
		return {
			"target_state_name": transition.target_state_name,
			"conditionals": transition.conditionals.map(_schemas.AIConditionalSchema.to_dict),
		}
	
	func to_domain(json: Dictionary) -> AITransition:
		var transition: AITransition = AITransition.new(json["target_state_name"])
		transition.conditionals.append_array(json["conditionals"].map(_schemas.AIConditionalSchema.to_domain))
		return transition


class ConditionalSchema extends SchemaBase:
	func to_dict(conditional: AIConditional) -> Dictionary:
		return {
			"condition_function_name": conditional.condition_function_name,
			"condition_argument_names": conditional.condition_argument_names,
		}
	
	func to_domain(json: Dictionary) -> AIConditional:
		var condition_argument_names: Array[String] = []
		condition_argument_names.append_array(json["condition_argument_names"])
		return AIConditional.new(
			json["condition_function_name"],
			condition_argument_names,
		)
