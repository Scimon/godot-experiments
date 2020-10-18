extends KinematicBody2D

enum TURN { LEFT, RIGHT, NONE }
onready var shipVelocity = get_node("/root/ShipVelocity")
onready var Shot = preload("res://Shot.tscn")
var accelerating = false
var turning = TURN.NONE
var shooting = false
var shot_cool_down = 0

export var shot_cool_down_base = 0.2
export var shot_speed = 500
export var acceleration = 10
export var turn_rate = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event.is_action_pressed("accelerate"):
		accelerating = true
		$Engine.play()
	elif event.is_action_released("accelerate"):
		accelerating = false
		$Engine.stop()


	if event.is_action_pressed("shoot"):
		shooting = true
	elif event.is_action_released("shoot"):
		shooting = false
	
	if event.is_action_pressed("turn_left"):
		turning = TURN.LEFT
	elif event.is_action_released("turn_left"):
		turning = TURN.NONE
	if event.is_action_pressed("turn_right"):
		turning = TURN.RIGHT
	elif event.is_action_released("turn_right"):
		turning = TURN.NONE

func _physics_process(delta):
	shot_cool_down = max(shot_cool_down - delta, 0)
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

	if shooting && shot_cool_down == 0:
		shot_from($LeftShot)
		shot_from($RightShot)
		$Shot.play()
		shot_cool_down = shot_cool_down_base
		

func shot_from(node):
	var shot = Shot.instance()
	self.get_parent().add_child(shot)
	shot.velocity = Vector2.UP.rotated(rotation) * shot_speed
	shot.global_position = node.global_position
	shot.rotation = self.rotation

func collided(normal : Vector2):
	shipVelocity.SHIP_VELOCITY = shipVelocity.SHIP_VELOCITY + shipVelocity.SHIP_VELOCITY.bounce(normal.rotated(PI)) * .75
