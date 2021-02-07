class_name BlueprintEntity
extends Node2D

export var placeable := true

onready var _power_direction := find_node("PowerDirection")

func rotate_blueprint() -> void:
	if not _power_direction:
		return
	
	var directions: int = _power_direction.output_directions
	
	var new_directions := 0
	
	var checks = [
		[Types.Direction.LEFT, Types.Direction.UP],
		[Types.Direction.UP, Types.Direction.RIGHT],
		[Types.Direction.RIGHT, Types.Direction.DOWN],
		[Types.Direction.DOWN, Types.Direction.LEFT],
	]
	
	for check in checks:
		if directions & check[0]:
			new_directions |= check[1]
			
	_power_direction.output_directions = new_directions
