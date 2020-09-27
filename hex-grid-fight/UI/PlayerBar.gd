extends Control
class_name PlayerBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_character_name(name):
	$HBoxContainer/Name.text = name

func add_image(image):
	$HBoxContainer.add_child(image)
	image.set_transform(Transform2D(0.0,Vector2(11,10)))


func update_time_left(time):
	$TimeLeft.value = time * 10
