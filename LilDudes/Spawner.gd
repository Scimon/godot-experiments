tool
extends Node2D

onready var Spearman = preload("res://Creatures/Spearman.tscn")
onready var Spearimp = preload("res://Creatures/SpearImp.tscn")

export(Array, Resource) var teams

var next_spawn = 0

func _ready():
	EventBus.connect("spawn_creature", self, "_on_random_spawn")
	pass

func _on_random_spawn(position, team_id):
	var imp = Spearimp.instance()
	$YSort.add_child(imp)
	var vec = Vector2(rand_range(-1,1), rand_range(-1,1)).normalized() * 16
	imp.init(team_id, position + vec)

func get_team_by_id(id):
	for team in teams:
		if (team.team_id == id):
			return team
	return null

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
