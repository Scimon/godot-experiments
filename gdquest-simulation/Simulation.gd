extends Node

const BARRIER_ID := 1
const INVISIBLE_BARRIER_ID := 2

onready var _ground := $GameWorld/GroundTiles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var barriers: Array = _ground.get_used_cells_by_id(BARRIER_ID)
	
	for cellv in barriers:
		_ground.set_cellv(cellv, INVISIBLE_BARRIER_ID)
