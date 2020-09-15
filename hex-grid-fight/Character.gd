tool
extends Node2D

enum Body { RANGER, SAGE, KNIGHT }
export(Body) var body = Body.RANGER setget set_body
var ranges = {
	Body.RANGER : Vector2(0,5),
	Body.SAGE : Vector2(1,5),
	Body.KNIGHT : Vector2(0,11),
}


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_body(body)

func set_body(value):
	body = value
	if $Body:
		$Body.frame_coords = ranges[body]
