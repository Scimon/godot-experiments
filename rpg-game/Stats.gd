extends Node

export var max_health = 1 setget set_max_health
onready var health = max_health setget set_health
var starting_position = Vector2.ZERO
var target_locator;

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func reset_health():
	health = max_health
	emit_signal("health_changed", health)

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_max_health(value):
	max_health = max(1, value)
	if health != null:
		self.health = health
	emit_signal("max_health_changed", max_health)
