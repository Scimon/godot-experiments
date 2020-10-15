extends KinematicBody2D

var velocity : Vector2
onready var shipVelocity = get_node("/root/ShipVelocity")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	velocity = Vector2(randf(), randf()).normalized() * ( 2 * ( randi() % 20  ) )

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):
	var collision = self.move_and_collide( ( velocity + shipVelocity.SHIP_VELOCITY) * delta)
	if collision:
		if collision.collider.get("velocity") == null:
			velocity = (velocity + shipVelocity.SHIP_VELOCITY).bounce(collision.normal)
			collision.collider.collided(collision.normal)
		else:
			velocity = velocity.bounce(collision.normal) 
