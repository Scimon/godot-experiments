extends Control

signal message_displayed
var to_display: Array = []
var playing = false

func _ready():
	$Display.text = ""
	$AnimationPlayer.play("Reset")

func display_message(string):
	print("got " + string)
	$Display.text = string
	$AnimationPlayer.play("ShowText")
	yield($AnimationPlayer, "animation_finished")
	$Display.text = ""
	$AnimationPlayer.play("Reset")
	print("displayed" + string)
	emit_signal("message_displayed")


