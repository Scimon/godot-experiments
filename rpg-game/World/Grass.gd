extends Node2D
				   
const GrassEffect = preload("res://Effects/GrassEffect.tscn")                          
const spawnType = DeathSpawnData.spawners.GRASS

signal died(spawnType, pos)

func _ready():
	var scene = get_tree().current_scene
	connect("died", scene, "_handle_dead_signal")

func _on_HurtBox_area_entered(_area):
	create_grass_effect()
	emit_signal("died",spawnType,global_position)
	StoreDetails.on_death(self)
	queue_free()

func create_grass_effect():        
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position

func _enter_tree():
	StoreDetails.on_creation(self)
	
func _exit_tree():
	StoreDetails.on_leave(self)
