tool
extends StaticBody2D

const CONTROL_SPEED = 0.01

export var controlled = 0.0 setget set_controlled
export var team_id = -1 setget set_team_id
onready var sprite = $Sprite

var next_ai_spawn = 0

func _ready():
	set_sprite_params()

func _process(delta):
	if Engine.is_editor_hint():
		return
	var team_res : Team = self.owner.get_team_by_id(team_id)
	if (team_res && team_res.is_ai):
		next_ai_spawn -= delta
		if (next_ai_spawn <= 0):
			EventBus.emit_signal("spawn_creature", self.position, team_res.team_id)
			next_ai_spawn = rand_range(1,4) * 30 / (controlled+0.01)
	count_control()
	check_takeover()

func check_takeover():
	var f_team = -1
	if (team_id == -1):
		for body in $ControlZone.get_overlapping_bodies():
			if (f_team == -1):
				f_team = body.team_id
			if (body.team_id != f_team):
				return
	if(f_team == -1):
		return
	set_team_id(f_team)


func count_control():
	var current_control = controlled
	
	for body in $ControlZone.get_overlapping_bodies():
		if body.team_id == team_id:
			current_control += CONTROL_SPEED
		else:
			current_control -= CONTROL_SPEED
	set_controlled( current_control )
	if (controlled == 0):
		set_team_id( -1 )

func set_sprite_params():
	if (sprite):
		var team_res : Team = self.owner.get_team_by_id(team_id)
		if (team_res):
			sprite.material.set_shader_param("to_color", team_res.team_color)
		else:
			sprite.material.set_shader_param("to_color", Color(0.0,0.0,0.0,1.0))
		sprite.material.set_shader_param("controlled", float(controlled) / 50.0)

func set_team_id( value ):
	team_id = value
	set_sprite_params()
	return team_id

func set_controlled( value ):
	value = clamp(value,0.0,100.0)
	controlled = value
	set_sprite_params()
	return controlled



