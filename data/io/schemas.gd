class_name AISchemas
extends RefCounted

const SCHEMA_VERSION: String = "0.01"

var AIEntitySchema: EntitySchema = EntitySchema.new(self)
var AIPropertySchema: PropertySchema = PropertySchema.new(self)
var AIVariableSchema: VariablesSchema = VariablesSchema.new(self)
var AIStateSchema: StateSchema = StateSchema.new(self)
#var AIBehaviourSchema: BehaviourSchema = BehaviourSchema.new(self)


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


class PropertySchema extends SchemaBase:
	func to_dict(property: AIProperty) -> Dictionary:
		return {
			"property_name": property.property_name
		}


class VariablesSchema extends SchemaBase:
	func to_dict(variable: AIVariable) -> Dictionary:
		return {
			"variable_name": variable.variable_name
		}


class StateSchema extends SchemaBase:
	func to_dict(state: AIState) -> Dictionary:
		return {
			"state_name": state.state_name,
			#"behaviours": state.behaviours.map(_schemas.AIBehaviourSchema.to_dict)
		}


#class BehaviourSchema extends SchemaBase:
	#func to_dict(behaviour: AIBehaviour) -> Dictionary:
		#return {
			#"behaviour_name": behaviour.behaviour_name
			## TODO: This is likely to get complex
		#}
