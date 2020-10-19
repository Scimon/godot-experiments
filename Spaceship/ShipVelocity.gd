extends Node

export var SHIP_VELOCITY = Vector2.ZERO setget update_velocity
export var DELTA_V = 1000.0 setget update_delta_v
export var MAX_VELOCITY = 2000

func update_velocity(vec : Vector2):
	if vec.length() >= MAX_VELOCITY:
		vec = vec.normalized() * MAX_VELOCITY
	SHIP_VELOCITY = vec
	return vec

func update_delta_v(delta : float):
	DELTA_V = max(0, delta)
	return DELTA_V
