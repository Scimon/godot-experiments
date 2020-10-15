extends KinematicBody2D

enum TURN { LEFT, RIGHT, NONE }
onready var shipVelocity = get_node("/root/ShipVelocity")
var accelerating = false
var turning = TURN.NONE

export var acceleration = 10
export var turn_rate = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_up"):
		accelerating = true
	elif event.is_action_released("ui_up"):
		accelerating = false
	
	if event.is_action_pressed("ui_left"):
		turning = TURN.LEFT
	elif event.is_action_released("ui_left"):
		turning = TURN.NONE
	if event.is_action_pressed("ui_right"):
		turning = TURN.RIGHT
	elif event.is_action_released("ui_right"):
		turning = TURN.NONE

func _physics_process(delta):
	var vel_change = Vector2.ZERO
	var direction = Vector2.UP
	if turning == TURN.LEFT:
		rotation -= turn_rate * delta
	if turning == TURN.RIGHT:
		rotation += turn_rate * delta
	direction = direction.rotated(rotation).normalized()

	if accelerating:
		vel_change = direction * acceleration * delta
		$EngineLeft.emitting = true
		$EngineRight.emitting = true
	else:
		$EngineLeft.emitting = false
		$EngineRight.emitting = false
	
	shipVelocity.SHIP_VELOCITY -= vel_change

func collided(normal : Vector2):
	shipVelocity.SHIP_VELOCITY = shipVelocity.SHIP_VELOCITY.bounce(normal.rotated(PI)) * .75
