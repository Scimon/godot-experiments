tool
class_name Character
extends KinematicBody2D

var speed = 1.0 setget set_speed; 
export(float) var walk_speed = 1.0;
export(Vector2) var hex_pos = Vector2.ZERO setget set_hex_pos 
const CENTER_VEC = Vector2(12,14)
export(String) var character_name = "Unknown"
var acting = false
var selectable = {}
export(Array, Resource) var actions = []
var move_action = Move.new()
var current_action = move_action

signal action_done(speed_change)
signal time_updated(new_time)

# Called when the node enters the scene tree for the first time.
func _ready():
	$ActionSelect.set_actions(self, actions)

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
		if selectable.has(click):
			current_action.perform_action(self,$Grid,get_global_mouse_position())
			acting = false
			$Grid.visible = false
			$ActionDone.start()


func _on_ActionDone_timeout():
	emit_signal("action_done",update_speed())
