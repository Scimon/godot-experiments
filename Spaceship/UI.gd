extends VBoxContainer

onready var shipVelocity = get_node("/root/ShipVelocity")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Velocity.text = "Vel: " + String(shipVelocity.SHIP_VELOCITY.length())		
	$Fuel.text = "DV: " + String(shipVelocity.DELTA_V)
