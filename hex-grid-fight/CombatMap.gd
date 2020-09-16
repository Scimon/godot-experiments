extends Node2D

onready var walls = $HexWalls

# Called when the node enters the scene tree for the first time.
func _ready():
	var center_vec = Vector2(12,14)
	var start = walls.map_to_world(Vector2(8,1)) + center_vec
	var end = walls.map_to_world(Vector2(10,2)) + center_vec
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(start, end)
	
	$Line2D.set_points([start,end])
	
	print(start)
	print(end)
	print(result)
