extends Action
class_name Move

func display_possible_selections(hex_pos: Vector2, grid : TileMap):
	return select_cells(hex_pos, grid)
	
func perform_action(actor, grid : TileMap, click: Vector2):
	var target_hex = grid.world_to_map(click)
	actor.hex_pos = target_hex
