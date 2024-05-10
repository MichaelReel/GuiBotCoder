class_name ActionGui
extends Object

var state_gui: StateGui
var action: AIAction
var treeitem: TreeItem

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
	treeitem = state_gui.treeitem.get_tree().create_item(state_gui.actions_treeitem)
	
	update()

func update() -> void:
	pass

class AssignmentGui extends ActionGui:	
	func update() -> void:
		var local_action: AIAction.AIAssignment = action as AIAction.AIAssignment
		var text: String = "Assign "
		text += "`" + local_action.assign_variable_name + "` = "
		text += local_action.function_name
		text += "("
		var first: bool = true
		for arg_name in local_action.function_argument_names:
			if not first:
				text += ", "
			else:
				first = false
			text += "`" + arg_name + "`"
		text += ")"
		treeitem.set_text(Column.TITLE, text)

class TravelGui extends ActionGui:
	func update() -> void:
		var local_action: AIAction.AITravel = action as AIAction.AITravel
		var text: String = "Travel"
		text += "("
		text += "`" + local_action.direction_variable_name + "`"
		text += ", "
		text += "`" + local_action.distance_variable_name + "`"
		text += ")"
		treeitem.set_text(Column.TITLE, text)

class StopGui extends ActionGui:
	func update() -> void:
		var text: String = "Stop()"
		treeitem.set_text(Column.TITLE, text)

class PerformGui extends ActionGui:
	func update() -> void:
		var local_action: AIAction.AIPerform = action as AIAction.AIPerform
		var text: String = local_action.function_name
		text += "("
		var first: bool = true
		for arg_name in local_action.function_argument_names:
			if not first:
				text += ", "
			else:
				first = false
			text += "`" + arg_name + "`"
		text += ")"
		treeitem.set_text(Column.TITLE, text)
		

