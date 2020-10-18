extends Node

export var SHIP_VELOCITY = Vector2.ZERO setget update_velocity
var MAX_VELOCITY = 5000

func update_velocity(vec : Vector2):
	if vec.length() >= MAX_VELOCITY:
		vec = vec.normalized() * MAX_VELOCITY
	SHIP_VELOCITY = vec
	return vec
