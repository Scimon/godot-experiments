class_name TurnOrder
extends Node

class SpeedSorter:
	static func sort_on_speed(a, b):
		if a.current_speed < b.current_speed:
			return true
		return false

var turn_order = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for unit in $Units.get_children():
		turn_order.append({"unit": unit, "current_speed": unit.speed })
		unit.connect("action_done",self,"_handle_action_done")
	update_display()
	
func update_display():
	turn_order.sort_custom(SpeedSorter, "sort_on_speed")
	for node in $TurnDisplay/VBoxContainer.get_children():
		node.queue_free()
		
	for unit in turn_order:
		var option = ToolButton.new()
		option.text = unit.unit.character_name
		$TurnDisplay/VBoxContainer.add_child(option)
	next_character()


func _handle_action_done(speed):
	turn_order[0].current_speed += speed
	update_display()

func next_character():
	turn_order[0].unit.action_select()
