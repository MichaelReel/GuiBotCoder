class_name ConditionalGui
extends Object

var transition_gui: TransitionGui
var conditional: AIConditional
var treeitem: TreeItem

func _init(transition_gui: TransitionGui, conditional: AIConditional) -> void:
	self.transition_gui = transition_gui
	self.conditional = conditional
	treeitem = transition_gui.treeitem.get_tree().create_item(transition_gui.treeitem)
	
	update()

func update() -> void:
	var text: String = "Conditional "
	text += conditional.condition_function_name
	text += "("
	var first: bool = true
	for arg_name in conditional.condition_argument_names:
		if not first:
			text += ", "
		else:
			first = false
		text += "`" + arg_name + "`"
	text += ")"
	treeitem.set_text(Column.TITLE, text)
