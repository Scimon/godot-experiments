extends Node2D

onready var Spearman = preload("res://Creatures/Spearman.tscn")

func _ready():
	pass

func valid_start(event : InputEvent):
	if ! "position" in event :
		return
	var vec = $TileMap.world_to_map(event.position / 2)
	var cord = $TileMap.get_cell_autotile_coord(vec.x, vec.y)
	return cord[0] == 1 && cord[1] == 1
	

func _unhandled_input(event : InputEvent):
	if ! valid_start(event):
		return
		
	if event.is_action_released("left_click"):
		var character = Spearman.instance()
		$YSort.add_child(character)
		character.init(0, Vector2( int(event.position.x), int(event.position.y) ))
	if event.is_action_released("right_click"):
		EventBus.emit_signal("move_to_location", event.position, 0)
