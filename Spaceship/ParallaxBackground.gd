extends ParallaxBackground

onready var shipVelocity = get_node("/root/ShipVelocity")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.scroll_offset += shipVelocity.SHIP_VELOCITY * delta
