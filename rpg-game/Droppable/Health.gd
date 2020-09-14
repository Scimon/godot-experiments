extends Node2D

enum {
	OK
	FAILING
}

var state = OK
onready var flickerPlayer = $FlickerPlayer
var starting_pos = Vector2.ZERO
export var bounce = 20
export var bounce_range = 5
var velocity = 0
var target_position
var direction = Vector2.DOWN

func set_global_position(value):
	global_position = value
	starting_pos = global_position
	set_target()

func set_target():
	direction = -direction
	target_position = starting_pos + ( direction * bounce_range )

func _physics_process(delta):
	if starting_pos != Vector2.ZERO:
		if starting_pos.distance_to(global_position) >= bounce_range:
			set_target()
		global_position = global_position.move_toward(target_position, bounce * delta)
	
	

func _on_Area2D_body_entered(body):
	if PlayerStats.health < PlayerStats.max_health:
		PlayerStats.health += 1
		queue_free()	

func _on_Timer_timeout():
	match state:
		FAILING:
			queue_free()
		OK:
			flickerPlayer.play("Flicker")
			state = FAILING
