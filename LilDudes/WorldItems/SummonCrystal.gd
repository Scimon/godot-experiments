tool
extends StaticBody2D

export var controlled = 0 setget set_controlled
onready var sprite = $Sprite

func _ready():
	print("Setting controlled ", self.controlled)
	
	set_controlled( self.controlled )

func set_controlled( value ):
	value = int( clamp(value,0,100) )
	controlled = value
	print(sprite)
	if (sprite):
		print(  float(value) / 50.0 )
		sprite.material.set_shader_param("controlled", float(value) / 50.0)


