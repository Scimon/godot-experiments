extends Button

var action : Action
var actor : Character

signal action_selected(action)

func setup_button(set_actor : Character,set_action : Action):
	self.text = set_action.action_name
	self.action = set_action
	self.actor = set_actor
	connect("action_selected",set_actor,"action_selected")
	yield(get_tree(), "idle_frame")


func _on_ActionButton_pressed():
	emit_signal("action_selected", action)
