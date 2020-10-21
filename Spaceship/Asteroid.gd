extends KinematicBody2D

var velocity : Vector2
var rotation_speed : float
onready var shipVelocity = get_node("/root/ShipVelocity")
onready var Fuel = preload("res://Fuel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	velocity = Vector2(randf(), randf()).normalized() * ( 4 * ( randi() % 20  ) )
	rotation_speed = .1 - (randf() * .2)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):
	var collision = self.move_and_collide( ( velocity + shipVelocity.SHIP_VELOCITY) * delta)
	if collision:
		if collision.collider.get("velocity") == null:
			velocity = (velocity + shipVelocity.SHIP_VELOCITY).bounce(collision.normal)
			collision.collider.collided(collision.normal)
		else:
			velocity = velocity.bounce(collision.normal) 
	rotation = rotation + rotation_speed
	if global_position.distance_to(Vector2(512,300)) > 1000:
		queue_free()

func destroy():
	if randf() < 0.25:
		var fuel = Fuel.instance()
		self.get_parent().get_parent().add_child(fuel)
		fuel.global_position = self.global_position
	queue_free()
