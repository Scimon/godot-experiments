tool
extends AnimationPlayer

func get_y_offset():
	var out = self.get_parent().character_offset + 1
	if ( out >= 8 ) :
		out += 1
	return out * 16

func _ready():
	setup_animations()

func setup_animations():
	var idle_anim = make_animation(0)
	idle_anim.loop = true
	self.add_animation("Idle", idle_anim)
	self.add_animation("Walk", make_animation(4))
	self.add_animation("Attack", make_animation(8))
	self.add_animation("Hit", make_animation(12))
	self.add_animation("Death", make_animation(16))
	self.add_animation("Special", make_animation(20))
	self.clear_caches()
	
func make_base_animation( start_x_offset : int ):
	var anim = Animation.new()
	var track_index = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_index, ".:region_rect")
	anim.value_track_set_update_mode(track_index, Animation.UPDATE_DISCRETE)
	return [anim, track_index]
	
func make_animation( start_x_offset : int ):
	var opts = make_base_animation( start_x_offset )
	var anim = opts[0]
	var track_index = opts[1]
	for i in range(4):
		var index = 0.25 * i
		var x_offset = (start_x_offset + i) * 16
		var rect =  Rect2(x_offset, self.get_y_offset(),16, 16)
		anim.track_insert_key(track_index, index, rect)
	return anim 

func update_animations():
	for a in (self.get_animation_list()):
		self.remove_animation(a)
	self.setup_animations()
