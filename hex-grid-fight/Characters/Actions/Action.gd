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
	return [ result.empty(), null ]

func can_attack(grid: TileMap, hex_pos: Vector2, cell: Vector2):
	var start = grid.map_to_world(hex_pos) + CENTER_VEC
	var end = grid.map_to_world(cell) + CENTER_VEC
	
	var space_state = grid.get_world_2d().direct_space_state
	var result = space_state.intersect_ray(start, end, [self])
	if result.empty():
		return [ false, null ]
	if result.collider.get("character_name") != null:
		return [ true, result.collider ]
	return [ false, null ]

func apply_check(selectable, grid, hex_pos, function):
	for key in selectable:
		var result = self.call(function, grid, hex_pos, selectable[key].main_grid)
		selectable[key].selectable = result[0]
		selectable[key].target = result[1]
	return selectable

func select_cells(hex_pos : Vector2):
	var selectable = {}
	var move_vec
	var mapping = current_mapping(hex_pos)
	for key in mapping:
		move_vec = mapping[key]
		selectable[hex_pos+move_vec] = {
			"main_grid" : hex_pos + move_vec,
			"player_grid" : draw_map[key],
			"selectable" : true,
			"target": null,
		}
	return selectable

func draw_cells(selectable, grid):
	var valid_id = grid.tile_set.find_tile_by_name("valid")
	var invalid_id = grid.tile_set.find_tile_by_name("invalid")
	for key in selectable:
		if selectable[key].selectable:
			grid.set_cellv(selectable[key].player_grid, valid_id)
		else:
			grid.set_cellv(selectable[key].player_grid, invalid_id)

func display_possible_selections(_hex_pos : Vector2, _grid : TileMap):
	pass
	
func perform_action(_actor, _grid: TileMap, _click: Vector2):
	pass 
