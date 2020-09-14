extends Node2D

var spawnData = DeathSpawnData

func select_spawn( key, target_position ):
	if ! key in spawnData.SpawnList:
		return
		
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var maxWeight = max_weight( key )
	var selected = rng.randi_range(1,maxWeight)

	var option = select_option( key, selected )
	if option.path != "":
		spawn_option(option, target_position)
	
func spawn_option( option, target_position ):
	var Class = load(option.path)
	var spawned = Class.instance()
	get_parent().add_child(spawned)
	spawned.set_global_position(target_position)
	
func select_option( key, value):
	for option in spawnData.SpawnList[key]:
		if value <= option.weight:
			return option
		value -= option.weight
	print("Something went wrong")
	return {path=""}

func max_weight( key ):
	var weight = 0;
	for options in spawnData.SpawnList[key]:
		weight += options.weight
	return weight;
