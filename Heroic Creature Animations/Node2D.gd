extends Node2D

onready var Character = preload("res://Character.tscn")

func _ready():
	pass

func _unhandled_input(event : InputEvent):
	if event.is_action_released("left_click"):
		var character = Character.instance()
		$YSort.add_child(character)
		character.position = Vector2( int(event.position.x), int(event.position.y) )
		character.init()
	if event.is_action_released("right_click"):
		EventBus.emit_signal("move_to_location", event.position)
