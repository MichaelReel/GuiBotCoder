class_name InstructionGui
extends Tree

@export var plus_button_texture2d: Texture2D
@export var minus_button_texture2d: Texture2D
@export var modify_button_texture2d: Texture2D

var root: EntityGui

var _properties_gui: TreeItem
var _variables_gui: TreeItem
var _states_gui: TreeItem


func _ready() -> void:
	set_column_expand(Column.TITLE, true)
	set_column_expand(Column.ADD_BUTTON, false)
	set_column_expand(Column.REMOVE_BUTTON, false)
	set_column_expand(Column.EDIT_BUTTON, false)
	set_column_custom_minimum_width(Column.ADD_BUTTON, plus_button_texture2d.get_width())
	set_column_custom_minimum_width(Column.REMOVE_BUTTON, minus_button_texture2d.get_width())
	set_column_custom_minimum_width(Column.EDIT_BUTTON, modify_button_texture2d.get_width())
	
	# Create a sample data config
	var entity: AIEntity = AIEntity.new("Sample Data Entity")
	
	# Setup entity Properties
	entity.properties.append(AIProperty.new("Min Movement"))
	entity.properties.append(AIProperty.new("Max Movement"))
	entity.properties.append(AIProperty.new("Scan Range"))
	entity.properties.append(AIProperty.new("Melee Range"))
	entity.properties.append(AIProperty.new("Target Group"))
	
	# Setup entity level Variables
	entity.variables.append(AIVariable.new("Target"))
	
	# Create the base of all the States
	var wander_state: AIState = AIState.new("Wander")
	var approach_enemy_state: AIState = AIState.new("Approach Enemy")
	var melee_attack_enemy_state: AIState = AIState.new("Melee Attack Enemy")
	entity.states.append_array([wander_state, approach_enemy_state, melee_attack_enemy_state])
	
	# Setup Wander State
	wander_state.actions.append(AIAction.AIAssignment.new("Direction", "any_vector", []))
	wander_state.actions.append(AIAction.AIAssignment.new("Distance", "rand_range", ["Min Movement", "Max Movement"]))
	wander_state.actions.append(AIAction.AIAssignment.new("Target", "nearest_entity_in_group", ["Target Group"]))
	wander_state.actions.append(AIAction.AIAssignment.new("Target Range", "distance_to", ["Target"]))
	wander_state.actions.append(AIAction.AIAssignment.new("Target Level", "level_of", ["Target"]))
	wander_state.actions.append(AIAction.AITravel.new("Direction", "Distance"))
	
	var approach_transition: AITransition = AITransition.new("Approach Enemy")
	wander_state.transistions.append(approach_transition)
	approach_transition.conditionals.append(AIConditional.new("greater_or_equal", ["Max Enemy Level", "Target Level"]))
	approach_transition.conditionals.append(AIConditional.new("greater_than", ["Scan Range", "Target Range"]))
	
	# Setup Approach State
	approach_enemy_state.actions.append(AIAction.AIAssignment.new("Direction", "vector_to", ["Target"]))
	approach_enemy_state.actions.append(AIAction.AIAssignment.new("Target Range", "distance_to", ["Target"]))
	approach_enemy_state.actions.append(AIAction.AIAssignment.new("Distance", "min", ["Max Movement", "Target Range"]))
	approach_enemy_state.actions.append(AIAction.AITravel.new("Direction", "Distance"))
	
	var melee_attack_transition: AITransition = AITransition.new("Melee Attack Enemy")
	approach_enemy_state.transistions.append(melee_attack_transition)
	melee_attack_transition.conditionals.append(AIConditional.new("greater_or_equal", ["Melee Range", "Target Range"]))
	
	var wander_transition: AITransition = AITransition.new("Wander")
	approach_enemy_state.transistions.append(wander_transition)
	wander_transition.conditionals.append(AIConditional.new("greater_or_equal", ["Target Range", "Scan Range"]))
	
	# Setup Melee Attack State
	melee_attack_enemy_state.actions.append(AIAction.AIAssignment.new("Target Range", "distance_to", ["Target"]))
	melee_attack_enemy_state.actions.append(AIAction.AIStop.new())
	melee_attack_enemy_state.actions.append(AIAction.AIPerform.new("melee_attack", ["Target"]))
	
	var approach_2_transition: AITransition = AITransition.new("Approach Enemy")
	melee_attack_enemy_state.transistions.append(approach_2_transition)
	approach_2_transition.conditionals.append(AIConditional.new("greater_than", ["Target Range", "Melee Range"]))
	
	hide_root=true
	root = EntityGui.new(self, entity)

func _on_button_clicked(item: TreeItem, _column: int, id: int, _mouse_button_index: int) -> void:
	print(EditType.DESCRIPTION[id] + " to " + str(item))

func _get_random_direction() -> Vector2:
	return Vector2.from_angle(randf_range(0, PI * 2.0))
