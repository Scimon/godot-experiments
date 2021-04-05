extends Character

func begin_tracking(body):
	.begin_tracking(body)
	EventBus.emit_signal("move_to_location",body.position,self.team_id)
