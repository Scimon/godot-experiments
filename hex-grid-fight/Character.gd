tool
extends Node2D

enum Body { RANGER = 270, SAGE = 271 }
export(Body) var body = Body.RANGER setget set_body


# Called when the node enters the scene tree for the first time.
func _ready():
	$Body.frame = body

func set_body(value):
	body = value
	if $Body:
		$Body.frame = body
