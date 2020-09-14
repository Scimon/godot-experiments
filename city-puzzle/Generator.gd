extends Node2D

onready var tileMap = $TileMapBase
onready var baseTile = $BaseTile
onready var tileArray = $TileArray
export var height = 17
export var width = 17

var prev_pos;
var prev_piece;

var pieces = { "cross":
	[
		[15,5,15],
		[10,0,10],
		[15,5,15]
	],
	"" : [[15,15,15],[15,15,15],[15,15,15]]
}

var level = [
	["","","","",""],
	["","","","",""],
	["","","cross","",""],
	["","","","",""],
	["","","","",""],	
]

func place_tilev(vec,name):
	place_tile(vec.x,vec.y,name)

func place_tile(x,y,name):
	get_tile(x,y).frame = name

func get_tilev(vec):
	return get_tile(vec.x,vec.y)

func get_tile(x,y):
	var tilename = str(x) + "x" + str(y)
	return get_node("TileArray/" + tilename)

func place_piecev(vec,name):
	place_piece(vec.x,vec.y,name)
	
func place_piece(cx,cy,name):
	var piece = pieces[name]
	var delta = [0,1,2]
	for dy in delta:
		for dx in delta:
			place_tile(cx-1+dx, cy-1+dy, piece[dy][dx]) 

func highlight_piece(vec,r,g,b):
	var pos = piece_to_map(vec)
	var delta = [-1,0,1]
	for dy in delta:
		for dx in delta:
			var delta_vec = Vector2(dx,dy)
			var tile = get_tilev(pos + delta_vec)
			var tile_mat = tile.material
			tile_mat.set_shader_param("red_multiple",r)
			tile_mat.set_shader_param("green_multiple",g)
			tile_mat.set_shader_param("blue_multiple",b)

func clear_highlight(vec):
	highlight_piece(vec,1.0,1.0,1.0)

func map_to_piece(vec):
	var out = Vector2( floor( (vec.x - 1.0) / 3.0), floor( (vec.y - 1.0) / 3.0 ) )
	return out;
	
func piece_to_map(vec):
	var out = Vector2( (vec.x * 3.0) + 2.0, (vec.y * 3.0 ) + 2.0 )
	return out;

func _ready():
	for i in range(0,height):
		for j in range(0,width):
			new_tile(i,j)

	for i in range(0,level.size()):
		for j in range(0,level[i].size()):
			place_piecev(piece_to_map(Vector2(i,j)),level[i][j])
			
func new_tile(x,y):
	var vec = Vector2(x,y)			
	var map_vec = tileMap.map_to_world(vec)
	var tile = baseTile.duplicate()
	tile.global_position = map_vec
	tileArray.add_child(tile)
	tile.visible = true
	tile.frame = 15
	tile.name=str(x) + "x" + str(y)
	var tile_mat = tile.material.duplicate()
	tile.material = tile_mat

func _process(_delta):
	var grid_pos = tileMap.world_to_map(get_global_mouse_position())
	if grid_pos.x >= 1 && grid_pos.x < width-1 && grid_pos.y >= 1 && grid_pos.y < height-1:
		var piece_pos = map_to_piece(grid_pos)
		if prev_pos == null || grid_pos != prev_pos:
			if prev_pos != null:
				place_piecev(piece_to_map(prev_pos),prev_piece)
				clear_highlight(prev_pos)
#				clear_piecev(tileOverlay,piece_to_map(prev_pos))
			prev_pos = piece_pos
			prev_piece = level[piece_pos.y][piece_pos.x]
		place_piecev(piece_to_map( piece_pos ), "cross")
		if level[piece_pos.y][piece_pos.x] != "":
			highlight_piece(piece_pos,1.5,0.5,0.5)
		else:
			highlight_piece(piece_pos,0.5,0.5,0.5)			
	elif prev_pos != null:
		place_piecev(piece_to_map(prev_pos), prev_piece)
		clear_highlight(prev_pos)
		prev_pos = null
	 

func _input(event):
	if event is InputEventMouseButton:
		if prev_pos != null:
			prev_piece = "cross"
			level[prev_pos.y][prev_pos.x] = "cross"			
			clear_highlight(prev_pos)
