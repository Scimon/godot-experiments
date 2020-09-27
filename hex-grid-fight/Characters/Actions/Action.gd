extends Resource
class_name Action

export(String) var action_name
export(float) var base_speed = 1.0

const CENTER_VEC = Vector2(12,14)
func current_mapping(hex_pos : Vector2):
	if int(hex_pos.y) % 2 == 0:
		return { 
			"c_ul" : Vector2(-1,-1),
			"c_ur" : Vector2(0,-1),
			"c_l" : Vector2(-1,0),
			"c_r" : Vector2(1,0),
			"c_dl" : Vector2(-1,1),
			"c_dr" : Vector2(0,1),
		}
	else:
		return { 
			"c_ul" : Vector2(0,-1),
			"c_ur" : Vector2(1,-1),
			"c_l" : Vector2(-1,0),
			"c_r" : Vector2(1,0),
			"c_dl" : Vector2(0,1),
			"c_dr" : Vector2(1,1),
		}

var draw_map = current_mapping(Vector2.ZERO) 

func can_enter(grid: TileMap, hex_pos: Vector2, cell: Vector2):
	var start = grid.map_to_world(hex_pos) + CENTER_VEC
	var end = grid.map_to_world(cell) + CENTER_VEC
	
	var space_state = grid.get_world_2d().direct_space_state
	var result = space_state.intersect_ray(start, end, [self])
	return result.empty()

func select_cells(hex_pos : Vector2, grid: TileMap):
	var selectable = {}
	var move_vec
	var mapping = current_mapping(hex_pos)
	var valid_id = grid.tile_set.find_tile_by_name("valid")
	var invalid_id = grid.tile_set.find_tile_by_name("invalid")
	for key in mapping:
		move_vec = mapping[key]
		if can_enter(grid, hex_pos, hex_pos+move_vec):
			grid.set_cellv(draw_map[key], valid_id)
			selectable[hex_pos+move_vec] = true
		else:
			grid.set_cellv(draw_map[key], invalid_id)
	return selectable

func display_possible_selections(hex_pos : Vector2, grid : TileMap):
	pass
	
func perform_action(actor, grid: TileMap, click: Vector2):
	pass 
