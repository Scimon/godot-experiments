extends Button

var action : Action
var actor : Character

signal action_selected(action)

func setup_button(actor : Character,action : Action):
	self.text = action.action_name
	self.action = action
	self.actor = actor
	connect("action_selected",actor,"action_selected")
	yield(get_tree(), "idle_frame")


func _on_ActionButton_pressed():
	emit_signal("action_selected", action)
