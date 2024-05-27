class_name TransitionGui
extends Object

var state_gui: StateGui
var transition: AITransition
var treeitem: TreeItem

var conditional_guis: Array[ConditionalGui] = []

func _init(state_gui: StateGui, transition: AITransition) -> void:
	self.state_gui = state_gui
	self.transition = transition
	treeitem = state_gui.treeitem.get_tree().create_item(state_gui.transistions_treeitem)
	
	update()

func update() -> void:
	treeitem.set_text(Column.TITLE, "State Transition `" + transition.target_state_name + "`")
	treeitem.add_button(Column.REMOVE_BUTTON, state_gui.entity_gui.instruction_gui.minus_button_texture2d, EditType.REMOVE_TRANSISTION, false, "Remove Transition")
	treeitem.add_button(Column.ADD_BUTTON, state_gui.entity_gui.instruction_gui.plus_button_texture2d, EditType.ADD_CONDITION, false, "Add Conditional")
	
	conditional_guis.clear()
	
	for conditional in transition.conditionals:
		conditional_guis.append(ConditionalGui.new(self, conditional))
