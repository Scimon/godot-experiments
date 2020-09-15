extends Node2D

var move_vec = Vector2.ZERO
export var pan_speed = 500
export(Vector2) var min_position = Vector2(0,0)
export(Vector2) var max_position = Vector2(1200,1085)

var mapping = { 
	"ui_down" : Vector2.DOWN,
	"ui_up" : Vector2.UP,
	"ui_left" : Vector2.LEFT,
	"ui_right" : Vector2.RIGHT,
 }

func _physics_process(delta):
	for key in mapping:
		if Input.is_action_just_pressed(key):
			move_vec += mapping[key]
		if Input.is_action_just_released(key):
			move_vec -= mapping[key]
	
	if move_vec != Vector2.ZERO:
		position += move_vec.normalized() * pan_speed * delta
		position.x = clamp(position.x, min_position.x, max_position.x)
		position.y = clamp(position.y, min_position.y, max_position.y)
