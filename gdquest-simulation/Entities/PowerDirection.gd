extends Node2D

const REGIONS := {
	"UpLeft" : Rect2(899,134, 31, 17),
	"DownRight" : Rect2(950, 179, 31, 17),
	"UpRight" : Rect2(950,134, 31, 17),
	"DownLeft" : Rect2(899, 179, 31, 17),
}

export (Types.Direction, FLAGS) var output_directions: int = 15 setget _set_output_directions

onready var west := $W
onready var north := $N
onready var east := $E
onready var south := $S

func set_indicators() -> void:
	var checks := [ 
		{ "sprite": west, "direction": Types.Direction.LEFT, "region_true": REGIONS.UpLeft, "region_false": REGIONS.DownRight },
		{ "sprite": east, "direction": Types.Direction.RIGHT, "region_true": REGIONS.DownRight, "region_false": REGIONS.UpLeft },
		{ "sprite": north, "direction": Types.Direction.UP, "region_true": REGIONS.UpRight, "region_false": REGIONS.DownLeft },
		{ "sprite": south, "direction": Types.Direction.DOWN, "region_true": REGIONS.DownLeft, "region_false": REGIONS.UpRight },
		
	 ]
	
	for check in checks:
		if output_directions & check.direction != 0:
			check.sprite.region_rect = check.region_true
		else:
			check.sprite.region_rect = check.region_false

func _set_output_directions(value: int) -> void:
	output_directions = value
	if not is_inside_tree():
		yield(self, "ready")
	
	set_indicators()
