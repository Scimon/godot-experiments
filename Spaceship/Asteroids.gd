extends Node2D

export var max_asteroids = 50
onready var AsteroidSmall = preload("res://Asteroids/Asteroid-small.tscn")
onready var AsteroidMed = preload("res://Asteroids/Asteroid-med.tscn")
onready var AsteroidLrg = preload("res://Asteroids/Asteroid-lrg.tscn")
onready var shipVelocity = get_node("/root/ShipVelocity")
var CENTER = Vector2(512,300)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_Timer_timeout():
	var currentCount = $AsteroidGroup.get_child_count()
	if currentCount < max_asteroids:
		var velocity = shipVelocity.SHIP_VELOCITY
		if velocity.length() == 0:
			velocity = Vector2.DOWN
		velocity = velocity.rotated(PI)
		var target = get_point(velocity)
		var asteroid
		if currentCount % 3 == 0:
			asteroid = AsteroidLrg.instance()
		elif currentCount % 2 == 0:
			asteroid = AsteroidMed.instance()
		else:
			asteroid = AsteroidSmall.instance()
		asteroid.global_position = target
		$AsteroidGroup.add_child(asteroid)

func get_point(velocity : Vector2):
	var length = 600
	var rotate = (randf() * PI) - (PI / 2)
	var vector = CENTER + (velocity.normalized().rotated(rotate) * length)
	return vector

