class_name StateGui
extends Object

var entity_gui: EntityGui
var state: AIState
var treeitem: TreeItem
var actions_treeitem: TreeItem
var transistions_treeitem: TreeItem

var actions_guis: Array[ActionGui] = []
var transistions_guis: Array[TransitionGui] = []


func _init(entity_gui: EntityGui, state: AIState) -> void:
	self.entity_gui = entity_gui
	self.state = state
	
	treeitem = entity_gui.treeitem.get_tree().create_item(entity_gui.states_treeitem)
	actions_treeitem = _setup_actions_section()
	transistions_treeitem = _setup_transistions_section()
	
	update()

func update() -> void:
	# Make sure the GUI matches the elements in the state
	treeitem.set_text(Column.TITLE, state.state_name)
	treeitem.add_button(
		Column.EDIT_BUTTON,
		entity_gui.instruction_gui.modify_button_texture2d,
		EditType.EDIT_STATE,
		false,
		"Edit State"
	)
	treeitem.add_button(
		Column.REMOVE_BUTTON,
		entity_gui.instruction_gui.minus_button_texture2d,
		EditType.REMOVE_STATE,
		false,
		"Remove State"
	)
	
	# Until performance is an issue, just recreate all gui
	actions_guis.clear()
	transistions_guis.clear()
	
	for action in state.actions:
		actions_guis.append(ActionGui.get_gui_for_action(self, action))
	
	for transition in state.transistions:
		transistions_guis.append(TransitionGui.new(self, transition))

func _setup_actions_section() -> TreeItem:
	var actions: TreeItem = entity_gui.treeitem.get_tree().create_item(treeitem)
	actions.set_text(Column.TITLE, "State Actions")
	actions.add_button(Column.ADD_BUTTON, entity_gui.instruction_gui.plus_button_texture2d, EditType.ADD_ACTION, false, "Add Action")
	return actions

func _setup_transistions_section() -> TreeItem:
	var transistions: TreeItem = entity_gui.treeitem.get_tree().create_item(treeitem)
	transistions.set_text(Column.TITLE, "State Transitions")
	transistions.add_button(Column.ADD_BUTTON, entity_gui.instruction_gui.plus_button_texture2d, EditType.ADD_TRANSISTION, false, "Add Transition")
	return transistions
