class_name TurnOrder
extends Node

class SpeedSorter:
	static func sort_on_speed(a, b):
		if a.unit.speed < b.unit.speed:
			return true
		return false

var turn_order = []
var processing = false
onready var PlayerBar = preload("res://UI/PlayerBar.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for unit in $Units.get_children():
		var playerBar = PlayerBar.instance()
		$TurnDisplay/TimeList.add_child(playerBar)
		playerBar.set_character_name(unit.character_name)
		playerBar.add_image(unit.get_node("./ComplexCharacterBody").duplicate())
		playerBar.update_time_left(unit.speed)
		unit.connect("time_updated",playerBar,"update_time_left")
		turn_order.append({"unit": unit, "bar": playerBar })
		unit.connect("action_done",self,"_handle_action_done")
	update_display()
	activate_processing()

func activate_processing():
	if turn_order.size() > 0:
		processing = true

func _process(delta):
	if not processing:
		return
	for index in range(turn_order.size()):
		turn_order[index]["unit"].speed = max(turn_order[index]["unit"].speed - delta, 0)
	if turn_order[0]["unit"].speed == 0:
		processing = false
		turn_order[0]["unit"].action_select()

func update_display():
	turn_order.sort_custom(SpeedSorter, "sort_on_speed")
		
	for index in range(turn_order.size()):
		var node = $TurnDisplay/TimeList.get_node(turn_order[index]["bar"].get_path())
		$TurnDisplay/TimeList.move_child(node,index)

func _handle_action_done(speed):
	turn_order[0].unit.speed += speed
	update_display()
	activate_processing()
