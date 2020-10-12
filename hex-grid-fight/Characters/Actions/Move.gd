extends Action
class_name Move

func display_possible_selections(hex_pos: Vector2, grid : TileMap):
	var selectable = select_cells(hex_pos)
	selectable = apply_check(selectable, grid, hex_pos, "can_enter")
	draw_cells(selectable,grid)
	return selectable
	
func perform_action(actor, grid : TileMap, click: Vector2):
	var target_hex = grid.world_to_map(click)
	actor.hex_pos = target_hex
	actor.action_complete()
