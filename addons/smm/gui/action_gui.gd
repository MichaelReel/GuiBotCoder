class_name ActionGui
extends Object

var state_gui: StateGui
var action: AIAction
var treeitem: TreeItem
var action_text: String

static func get_gui_for_action(state_gui: StateGui, action: AIAction) -> ActionGui:
	if action is AIAction.AIAssignment:
		return AssignmentGui.new(state_gui, action)
	if action is AIAction.AITravel:
		return TravelGui.new(state_gui, action)
	if action is AIAction.AIStop:
		return StopGui.new(state_gui, action)
	if action is AIAction.AIPerform:
		return PerformGui.new(state_gui, action)
	return ActionGui.new(state_gui, action)

func _init(state_gui: StateGui, action: AIAction) -> void:
	self.state_gui = state_gui
	self.action = action
	treeitem = state_gui.treeitem.get_tree().create_item(state_gui.action_treeitem)
	
	update_text() 
	add_edit_button()
	add_delete_button()

func update_text() -> void:
	update()
	treeitem.set_text(Column.TITLE, action_text)

# To be overwritten
func update() -> void:
	pass

# Can be overwritten, for example by the stop action which doesn't need edited
func add_edit_button() -> void:
	treeitem.add_button(
		Column.EDIT_BUTTON,
		state_gui.entity_gui.instruction_gui.modify_button_texture2d,
		EditType.EDIT_ACTION,
		false,
		"Edit Action"
	)

# Can be overwritten
func add_delete_button() ->void:
	treeitem.add_button(
		Column.REMOVE_BUTTON,
		state_gui.entity_gui.instruction_gui.minus_button_texture2d,
		EditType.REMOVE_ACTION,
		false,
		"Remove Action"
	)

class AssignmentGui extends ActionGui:
	func update() -> void:
		var local_action: AIAction.AIAssignment = action as AIAction.AIAssignment
		action_text = "Assign "
		action_text += "`" + local_action.assign_variable_name + "` = "
		action_text += local_action.function_name
		action_text += "("
		var first: bool = true
		for arg_name in local_action.function_argument_names:
			if not first:
				action_text += ", "
			else:
				first = false
			action_text += "`" + arg_name + "`"
		action_text += ")"

class TravelGui extends ActionGui:
	func update() -> void:
		var local_action: AIAction.AITravel = action as AIAction.AITravel
		action_text = "Travel"
		action_text += "("
		action_text += "`" + local_action.direction_variable_name + "`"
		action_text += ", "
		action_text += "`" + local_action.distance_variable_name + "`"
		action_text += ")"

class StopGui extends ActionGui:
	func update() -> void:
		action_text = "Stop Movement"

	func add_edit_button() -> void:
		pass

class PerformGui extends ActionGui:
	func update() -> void:
		var local_action: AIAction.AIPerform = action as AIAction.AIPerform
		action_text = local_action.function_name
		action_text += "("
		var first: bool = true
		for arg_name in local_action.function_argument_names:
			if not first:
				action_text += ", "
			else:
				first = false
			action_text += "`" + arg_name + "`"
		action_text += ")"
