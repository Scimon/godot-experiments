tool
class_name Character
extends KinematicBody2D

var speed = 1.0 setget set_speed; 
export(float) var walk_speed = 1.0;
export(Vector2) var hex_pos = Vector2.ZERO setget set_hex_pos 
export(String) var character_name = "Unknown"
export(int) var stun_threshold = 1
export(int) var lethal_threshold = 1
export(int) var base_attack = 50
export(int) var base_defence = 50

var acting = false
var selectable = {}
export(Array, Resource) var actions = []
var move_action = Move.new()
var current_action = move_action
const CENTER_VEC = Vector2(12,14)

var ActionDisplay = preload("res://Characters/ActionDisplay.tscn")

signal action_done(speed_change)
signal time_updated(new_time)

# Called when the node enters the scene tree for the first time.
func _ready():
	$ActionSelect.set_actions(self, actions)

func get_attack():
	return current_action.attack_skill + base_attack
	
func get_defence():
	return base_defence

func action_select():
	$Camera.current = true
	acting = true
	$ActionSelect.visible = true

func action_selected(action):
	$ActionSelect.visible = false
	current_action = action
	selectable = current_action.display_possible_selections(hex_pos, $Grid)
	$Grid.visible = true

func update_speed():
	return current_action.base_speed * walk_speed

func set_speed(value):
	speed = value
	emit_signal("time_updated",value)

func set_hex_pos(value):
	hex_pos = value
	if $Grid:
		global_position = $Grid.map_to_world(value) + CENTER_VEC
	return value

func _unhandled_input(event):
	if not acting:
		return
	if event.is_action_released("click"):
		var click = $Grid.world_to_map(get_global_mouse_position())
		if selectable.has(click) && selectable[click].selectable:
			current_action.perform_action(self,$Grid,get_global_mouse_position())
			acting = false
			$Grid.visible = false
	if event.is_action_pressed("cancel_action"):
		$Grid.visible = false
		acting = false
		action_select()

	
func action_complete():	
	emit_signal("action_done",update_speed())

func display_message(message):
	var actionDisplay = ActionDisplay.instance()
	self.add_child(actionDisplay)
	actionDisplay.display_message(message)
	yield(actionDisplay, "message_displayed")	
	return

func attack(attacker, type):
	display_message(attacker.character_name + " " + type + " at " + character_name)
	var difference = attack_check(attacker)
	if difference > 0:
		var damage_mod = defence_check( difference, self )
	action_complete()

func d100_roll():
	randomize()
	return randi() % 100 + 1

func attack_check(attacker):
	var attack = attacker.get_attack()
	var roll =  d100_roll()
	attacker.display_message("Needs " + str(attack) + " got " + str(roll) )
	if roll <= attack:
		return attack - roll
	else:
		attacker.display_message("Miss")
		return -1

func defence_check(attack_value, target):
	var defence = target.get_defence()
	var roll = d100_roll()
	target.display_message("Needs " + str(defence) + " got " + str(roll) )
	var difference = defence - roll
	if roll <= defence:
		if difference < attack_value:
			target.display_message("Glancing blow")
			return 0.5
		else:
			target.display_message("Dodged")
			return 0
	else:
		if difference * 2 < attack_value:
			target.display_message("Critical Hit")
			return 2
		else:
			target.display_message("Hit")
			return 1

	
