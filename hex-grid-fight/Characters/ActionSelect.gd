extends Control

var ActionButton = preload("res://Characters/ActionButton.tscn")

func set_actions(actor : Character, actions: Array):
	for action in actions:
		var button = ActionButton.instance()
		$ActionSelector.add_child(button)
		button.setup_button(actor, action)

