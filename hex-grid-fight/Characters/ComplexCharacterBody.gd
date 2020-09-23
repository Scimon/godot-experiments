tool
extends Node2D

enum Body { PALE, TAN, BROWN, GREEN }
export(Body) var body = Body.TAN setget set_body
var ranges = {
	Body.PALE : Vector2(0,0),
	Body.TAN : Vector2(0,1),
	Body.BROWN : Vector2(0,2),
	Body.GREEN : Vector2(0,3),
}
var chest_material_bases = {
	0 : Vector2(6,0),
	1 : Vector2(10,0),
	2 : Vector2(14,0),
	3 : Vector2(6,5),
	4 : Vector2(10,5),
	5 : Vector2(14,5),
}

export(int,5) var chest_material = 0 setget set_chest_material
export(int,19) var chest_design = 0 setget set_chest_design

func set_body(value):
	body = value
	if $Body:
		$Body.frame_coords = ranges[body]
	return value

func set_chest_design(value):
	chest_design = value
	apply_chest()
	return value

func set_chest_material(value):
	chest_material = value
	apply_chest()
	return value

func apply_chest():
	if $Chest:
		var base = chest_material_bases[chest_material]
		base.x += chest_design % 4
		base.y += floor(chest_design / 4)
		$Chest.frame_coords = base


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_body(body)
	self.set_chest_material(chest_material)
