extends AnimatedSprite

onready var CharacterFactory = preload("res://Character.tscn")

func _ready():
	randomize()

func _on_Timer_timeout():
	if ( rand_range(0,10) < 5 ):
		var imp = CharacterFactory.instance()
		self.get_parent().add_child(imp)
		imp.character_type = Character.CharacterTypes.Spear_Imp
		imp.position = self.position + Vector2( int(rand_range(-50,50)), int(rand_range(-50,50)) )
		imp.init()
