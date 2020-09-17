tool
extends Node2D

enum Body { RANGER, SAGE, KNIGHT }
export(Body) var body = Body.RANGER setget set_body
export(Vector2) var hex_pos = Vector2.ZERO setget set_hex_pos 
var ranges = {
	Body.RANGER : Vector2(0,5),
	Body.SAGE : Vector2(1,5),
	Body.KNIGHT : Vector2(0,11),
}
const CENTER_VEC = Vector2(12,14)
# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_body(body)

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

func _physics_process(delta):
	var move_vec = Vector2.ZERO
	var mapping = current_mapping()
	for key in mapping:
		if Input.is_action_just_pressed(key):
			move_vec += mapping[key]
	if can_enter(hex_pos+move_vec):
		set_hex_pos(hex_pos + move_vec)

func can_enter(cell):
	var start = $Grid.map_to_world(hex_pos) + CENTER_VEC
	var end = $Grid.map_to_world(cell) + CENTER_VEC
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(start, end, [self])
	return result.empty()
