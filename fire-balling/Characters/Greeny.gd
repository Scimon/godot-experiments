extends KinematicBody2D

export(float) var gravity = 10.0
var velocity = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity += Vector2.DOWN * gravity
	velocity = move_and_slide(velocity, Vector2.UP)
