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

func get_point(velocity : Vector2):
	var length = 600
	var rotate = (randf() * PI) - (PI / 2)
	var vector = CENTER + (velocity.normalized().rotated(rotate) * length)
	return vector

