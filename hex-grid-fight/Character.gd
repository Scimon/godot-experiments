tool
extends Node2D

enum Body { RANGER, SAGE }
export(Body) var body = Body.RANGER setget set_body
var ranges = {
	Body.RANGER : {
		"x" : 0, "y": 85
	},
	Body.SAGE : {
		"x" : 17, "y": 85
	}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	print(ranges)
#	print(Body)
	self.set_body(body)

func set_body(value):
	body = value
	if $Body != null:
		$Body.set_region_rect( Rect2( ranges[body]["x"], ranges[body]["y"], 16, 16 ) )
