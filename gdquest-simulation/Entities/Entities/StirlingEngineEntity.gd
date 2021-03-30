extends Entity

const BOOTUP_TIME := 6.0
const SHUTDOWN_TIME := 3.0

onready var animation_player := $AnimationPlayer
onready var tween := $Tween
onready var shaft := $PistonShaft
onready var power := $PowerSource

func _ready() -> void:
	animation_player.play("StirlingEngine")
	
	tween.interpolate_method(self, "_update_efficiency", 0.0, 1.0, BOOTUP_TIME)
	tween.interpolate_property(animation_player, "playback_speed", 0, 1, BOOTUP_TIME)
	tween.interpolate_property(shaft, "modulate", Color.white, Color(0.5,1,0.5), BOOTUP_TIME )
	tween.start()

func _update_efficiency(value: float) -> void:
	power.efficiency = value
	Events.emit_signal("info_updated", self)

func get_info() -> String:
	return "%.1f j/s" % power.get_effective_power()
