extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts
const HEART_WIDTH = 15

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = HEART_WIDTH * hearts
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = HEART_WIDTH * max_hearts
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed",self,"set_hearts")
	PlayerStats.connect("max_health_changed",self,"set_max_hearts")

