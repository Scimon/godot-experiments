extends StaticBody2D

onready var Imp = preload("res://Creatures/SpearImp.tscn")

func _ready():
	randomize()

func _on_Timer_timeout():
	if ( rand_range(0,10) < 5 ):
		var imp = Imp.instance()
		self.get_parent().add_child(imp)
		var vec = Vector2(rand_range(-1,1), rand_range(-1,1)).normalized() * 16
		imp.init(1, self.position + vec)
		#imp.move_to_location = self.position + Vector2( rand_range(-128, 128) + 16, rand_range(-128, 128) + 16)