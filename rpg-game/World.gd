extends Node2D

onready var deathSpawner = $YSort/DeathSpawner

func _handle_dead_signal( type, position ):
	deathSpawner.call_deferred( "select_spawn", type, position)

