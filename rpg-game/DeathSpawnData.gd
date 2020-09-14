extends Node

enum spawners {
	GRASS
	BAT
	SPIDER
}

var SpawnList = {
	spawners.GRASS : [
		# Empty Path for no spawn
		{ path = "", weight = 40 },
		# Small chance of getting health
		{ path = "res://Droppable/Health.tscn", weight = 10 },
		# V Small chance of a bat
		{ path = "res://Enemies/Spider.tscn", weight = 1 },
	],
	spawners.BAT : [
		# Empty Path for no spawn
		{ path = "", weight = 10 },
		# Small chance of getting health
		{ path = "res://Droppable/Health.tscn", weight = 20 },
	],
	spawners.SPIDER : [
		# Empty Path for no spawn
		{ path = "", weight = 5 },
		# Small chance of getting health
		{ path = "res://Droppable/Health.tscn", weight = 20 },
	]
};
