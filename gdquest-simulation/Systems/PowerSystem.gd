class_name PowerSystem
extends Reference

var power_sources := {}

var power_receivers := {}

var power_movers := {}

var paths := []

var cells_travelled := []

var receivers_already_provided := {}

func _init() -> void:
	Events.connect("entity_placed", self, "_on_entity_placed")
	Events.connect("entity_removed", self, "_on_entity_removed")
	Events.connect("systems_ticked", self, "_on_systems_ticked")

func _on_entity_placed(entity, cellv: Vector2) -> void:
	var retrace := false
	
	if entity.is_in_group(Types.POWER_SOURCES):
		power_sources[cellv] = _get_power_source_from(entity)
		retrace = true
	
	if entity.is_in_group(Types.POWER_RECEIVERS):
		power_receivers[cellv] = _get_power_receiver_from(entity)
		retrace = true
	
	if entity.is_in_group(Types.POWER_MOVERS):
		power_movers[cellv] = entity
		retrace = true
	
	if retrace:
		_retrace_paths()

func _on_entity_removed(_entity, cellv: Vector2)-> void:
	var retrace := power_sources.erase(cellv)
	retrace = power_receivers.erase(cellv) or retrace
	retrace = power_movers.erase(cellv) or retrace
	
	if retrace:
		_retrace_paths()

func _on_systems_ticked(delta: float) -> void:
	receivers_already_provided.clear()
	
	for path in paths:
		var power_source: PowerSource = power_sources[path[0]]
		
		var available_power := power_source.get_effective_power()

		var power_draw := 0.0
		
		for cell in path.slice(1, path.size()-1):
			if not power_receivers.has(cell):
				continue
			var power_receiver: PowerReceiver = power_receivers[cell]
			var power_required := power_receiver.get_effective_power()
			
			if receivers_already_provided.has(cell):
				var receiver_total: float = receivers_already_provided[cell]
				if receiver_total >= power_required:
					continue
				else:
					power_required -= receiver_total
			
			power_receiver.emit_signal("received_power", min(available_power, power_required), delta)
			
			power_draw += power_required
			
			if not receivers_already_provided.has(cell):
				receivers_already_provided[cell] = min(available_power, power_required)
			else:
				receivers_already_provided[cell] += min(available_power, power_required)
			available_power -= power_required
					
		power_source.emit_signal("power_updated", power_draw, delta)

func _retrace_paths() -> void:
	paths.clear()
	
	for source in power_sources.keys():
		cells_travelled.clear()
		
		var path := _trace_path_from(source, [source])
		
		paths.push_back(path)

func _trace_path_from(cellv: Vector2, path: Array) -> Array:
	cells_travelled.push_back(cellv)
	var direction := 15
	if power_sources.has(cellv):
		direction = power_sources[cellv].output_direction
	var receivers := _find_neighbours_in(cellv, power_receivers, direction)
	
	for receiver in receivers:
		if not receiver in cells_travelled:
			direction = _combine_directions(receiver, cellv)
			var power_receiver: PowerReceiver = power_receivers[receiver]
			
			if( 
				( 
					direction & Types.Direction.RIGHT != 0 
					and power_receiver.input_direction & Types.Direction.LEFT == 0
				)
				or ( 
					direction & Types.Direction.DOWN != 0 
					and power_receiver.input_direction & Types.Direction.UP == 0
				)
				or ( 
					direction & Types.Direction.LEFT != 0 
					and power_receiver.input_direction & Types.Direction.RIGHT == 0
				)
				or ( 
					direction & Types.Direction.UP != 0 
					and power_receiver.input_direction & Types.Direction.DOWN == 0
				)
			):
				continue
			
			path.push_back(receiver)
	
	var movers := _find_neighbours_in(cellv, power_movers)
	
	for mover in movers:
		if not mover in cells_travelled:
			path = _trace_path_from(mover, path)
	
	return path

func _combine_directions(receiver: Vector2, cellv: Vector2) -> int:
	if receiver.x < cellv.x:
		return Types.Direction.LEFT
	elif receiver.x > cellv.x:
		return Types.Direction.RIGHT
	elif receiver.y < cellv.y:
		return Types.Direction.UP
	elif receiver.y > cellv.y:
		return Types.Direction.DOWN
	
	return 0
	
func _find_neighbours_in(cellv: Vector2, collection: Dictionary, output_directions: int = 15) -> Array:
	var neighbours := []
	for neighbour in Types.NEIGHBOURS.keys():
		if neighbour & output_directions != 0:
			var key: Vector2 = cellv + Types.NEIGHBOURS[neighbour]
			if collection.has(key):
				neighbours.push_back(key)
	return neighbours
	
func _get_power_source_from(entity: Node) -> PowerSource:
	return _get_child_of_type(entity, PowerSource)

func _get_power_receiver_from(entity: Node) -> PowerReceiver:
	return _get_child_of_type(entity, PowerReceiver)
	
func _get_child_of_type(entity: Node, type):
	for child in entity.get_children():
		if child is type:
			return child
	return null
