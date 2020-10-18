extends Node2D

export var max_asteroids = 50
onready var Asteroid = preload("res://Asteroid.tscn")
onready var shipVelocity = get_node("/root/ShipVelocity")
var CENTER = Vector2(512,300)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_Timer_timeout():
	if $AsteroidGroup.get_child_count() < max_asteroids:
		var velocity = shipVelocity.SHIP_VELOCITY
		if velocity.length() == 0:
			velocity = Vector2.DOWN
		velocity = velocity.rotated(PI)
		var target = get_point(velocity)
		var asteroid = Asteroid.instance()
		asteroid.global_position = target
		$AsteroidGroup.add_child(asteroid)
#	if $AsteroidGroup.get_child_count():
#		$Timer.wait_time = 1 / $AsteroidGroup.get_child_count()
#	else:
#		$Timer.wait_time = 0.02

func get_point(velocity : Vector2):
	for vector in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
		if abs(velocity.angle_to(vector)) <= PI/4:
			return rand_point(vector)
	return rand_point(Vector2.UP)

func rand_point(direction : Vector2):
	if direction == Vector2.UP:
		return Vector2(randf() * 1024,(randf() * 30) - 50)
	if direction == Vector2.DOWN:
		return Vector2(randf() * 1024,620 + (randf() * 30))
	if direction == Vector2.LEFT:
		return Vector2((randf() * 30) - 50,randf() * 600)
	if direction == Vector2.RIGHT:
		return Vector2(1044 + (randf() * 30),randf() * 600)
	
	
