extends StaticBody2D

onready var CharacterFactory = preload("res://Character.tscn")

func _ready():
	randomize()

func _on_Timer_timeout():
	if ( rand_range(0,10) < 5 ):
		var imp = CharacterFactory.instance()
		self.get_parent().add_child(imp)
		imp.character_type = Character.CharacterTypes.Spear_Imp
		imp.position = self.position + Vector2( 0.0, 32.0 )
		imp.move_to_location = self.position + Vector2( rand_range(-128, 128) + 16, rand_range(-128, 128) + 16)
		imp.speed = 50.0
		imp.team_id = 1
		imp.init()
