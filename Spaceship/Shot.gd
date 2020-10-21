extends KinematicBody2D

var velocity : Vector2
onready var energy = 1000
#onready var shipVelocity = get_node("/root/ShipVelocity")

func _physics_process(delta):
	energy = energy - 1
	var collision = self.move_and_collide( velocity * delta)
	if collision:
		collision.collider.destroy()
		queue_free()
	if energy <= 0:
		queue_free()
	if global_position.distance_to(Vector2(512,300)) > 500:
		queue_free()

