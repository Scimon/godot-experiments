extends Action
class_name Punch

var selectable = {}

func display_possible_selections(hex_pos: Vector2, grid : TileMap):
	selectable = select_cells(hex_pos)
	selectable = apply_check(selectable, grid, hex_pos, "can_attack")
	draw_cells(selectable,grid)
	return selectable
	
func perform_action(actor, grid : TileMap, click: Vector2):
	var target_hex = grid.world_to_map(click)
	selectable[target_hex].target.attack(action_name)

