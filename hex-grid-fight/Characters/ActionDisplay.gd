extends Control

signal message_displayed

func display_message(string):
	$Display.text = string
	$AnimationPlayer.play("ShowText")


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("message_displayed")
	print("Message done")
	self.queue_free() # Replace with function body.
