extends KinematicBody2D

onready var velocity = Vector2.ZERO
onready var shipVelocity = get_node("/root/ShipVelocity")
export var fuel_level = 50
export var attraction_range = 300
export var attraction_speed = 50

func _physics_process(delta):
	var collision = self.move_and_collide( ( velocity + shipVelocity.SHIP_VELOCITY) * delta)
	if collision:
		shipVelocity.DELTA_V += fuel_level
		queue_free()
	var c_dist = global_position.distance_to(Vector2(512,300))
	if c_dist < attraction_range:
		velocity = global_position.direction_to(Vector2(512,300)).normalized() * (attraction_range / c_dist) * attraction_speed
	if c_dist > 1000:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
