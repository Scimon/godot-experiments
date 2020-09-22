tool
class_name Character
extends KinematicBody2D

export(float) var speed = 1.0; 

enum Body { RANGER, SAGE, KNIGHT }
export(Body) var body = Body.RANGER setget set_body
export(Vector2) var hex_pos = Vector2.ZERO setget set_hex_pos 
var ranges = {
	Body.RANGER : Vector2(0,5),
	Body.SAGE : Vector2(1,5),
	Body.KNIGHT : Vector2(0,11),
}
const CENTER_VEC = Vector2(12,14)
export(String) var character_name = "Unknown"
var acting = false
var selectable = {}

signal action_done(speed_change)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_body(body)

func action_select():
	$Camera.current = true
	acting = true
	select_cells()
	$Grid.visible = true

func set_body(value):
	body = value
	if $Body:
		$Body.frame_coords = ranges[body]
	return value

func set_hex_pos(value):
	hex_pos = value
	if $Grid:
		global_position = $Grid.map_to_world(value) + CENTER_VEC
	return value

func current_mapping():
	if int(hex_pos.y) % 2 == 0:
		return { 
			"c_ul" : Vector2(-1,-1),
			"c_ur" : Vector2(0,-1),
			"c_l" : Vector2(-1,0),
			"c_r" : Vector2(1,0),
			"c_dl" : Vector2(-1,1),
			"c_dr" : Vector2(0,1),
		}
	else:
		return { 
			"c_ul" : Vector2(0,-1),
			"c_ur" : Vector2(1,-1),
			"c_l" : Vector2(-1,0),
			"c_r" : Vector2(1,0),
			"c_dl" : Vector2(0,1),
			"c_dr" : Vector2(1,1),
		}

var draw_map = { 
			"c_ul" : Vector2(-1,-1),
			"c_ur" : Vector2(0,-1),
			"c_l" : Vector2(-1,0),
			"c_r" : Vector2(1,0),
			"c_dl" : Vector2(-1,1),
			"c_dr" : Vector2(0,1),
		} 

func select_cells():
	selectable = {}
	var move_vec
	var mapping = current_mapping()
	var valid_id = $Grid.tile_set.find_tile_by_name("valid")
	var invalid_id = $Grid.tile_set.find_tile_by_name("invalid")
	for key in mapping:
		move_vec = mapping[key]
		if can_enter(hex_pos+move_vec):
			$Grid.set_cellv(draw_map[key], valid_id)
			selectable[hex_pos+move_vec] = true
		else:
			$Grid.set_cellv(draw_map[key], invalid_id)

func can_enter(cell):
	var start = $Grid.map_to_world(hex_pos) + CENTER_VEC
	var end = $Grid.map_to_world(cell) + CENTER_VEC
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(start, end, [self])
	return result.empty()

func _unhandled_input(event):
	if not acting:
		return
	if event.is_action_released("click"):
		var click = $Grid.world_to_map(get_global_mouse_position())
		if selectable.has(click):
			self.hex_pos = click
			acting = false
			$Grid.visible = false
			$ActionDone.start()


func _on_ActionDone_timeout():
	emit_signal("action_done",speed)
