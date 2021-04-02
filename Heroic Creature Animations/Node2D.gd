extends Node2D

onready var Spearman = preload("res://Creatures/Spearman.tscn")
onready var SpearImp = preload("res://Creatures/SpearImp.tscn")

func _ready():
	pass

func _unhandled_input(event : InputEvent):
	if event.is_action_released("left_click"):
		var character = Spearman.instance()
		$YSort.add_child(character)
		character.init(0, Vector2( int(event.position.x), int(event.position.y) ))
	if event.is_action_released("right_click"):
		var character = SpearImp.instance()
		$YSort.add_child(character)
		character.init(1, Vector2( int(event.position.x), int(event.position.y) ))
