extends Node2D

onready var nav_2d : Navigation2D = $Navigation2D
onready var tower = $Tower
onready var spawner_points = $SpawnPoints
const Blob = preload("res://Blob.tscn") 

func make_blobs():
	for node in spawner_points.get_children():
		var blob = Blob.instance()
		blob.position = node.position
		add_child(blob)
		blob.path = nav_2d.get_simple_path(blob.global_position, tower.position)


func _on_Timer_timeout():
	make_blobs()
