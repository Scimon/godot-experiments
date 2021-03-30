class_name BlueprintEntity
extends Node2D

export var placeable := true

export var stack_size := 1

export(String, MULTILINE) var description := ""

var stack_count := 1

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

func display_as_inventory_icon() -> void:
	var panel_size: float = ProjectSettings.get_setting("game_gui/inventory_size")
	
	position = Vector2(panel_size * 0.5, panel_size * 0.75)
	
	scale = Vector2(panel_size / 100.0, panel_size / 100.0)
	
	modulate = Color.white
	
	if _power_direction:
		_power_direction.hide()
		
func display_as_world_entity() -> void:
	scale = Vector2.ONE
	position = Vector2.ZERO
	if _power_direction:
		_power_direction.show()
