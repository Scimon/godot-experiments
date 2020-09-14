extends Node2D

signal restart_game
signal quit_game


onready var stats = PlayerStats

func _ready():
	stats.connect("no_health", self, "display_menu")

func display_menu():
	visible = true
	get_tree().paused = true

func _on_Quit_pressed():
	get_tree().paused = false
	get_tree().quit()

func _on_Restart_pressed():
	stats.reset_health()
	get_tree().paused = false
	get_tree().reload_current_scene()
	visible = false
