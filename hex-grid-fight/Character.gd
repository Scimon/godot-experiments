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
