extends Node
class_name StoreDetails

static func on_creation(object):
	var path = object.get_path()
	if path in SavedScenes.saved_scenes:
		if SavedScenes.saved_scenes[path].dead:
			object.queue_free()
		else:
			object.global_position = SavedScenes.saved_scenes[path].position
	else:
		SavedScenes.saved_scenes[path] = { "dead": false}

static func on_death(object):
	SavedScenes.saved_scenes[object.get_path()] = { "dead" : true }

static func on_leave(object):
	var path = object.get_path()
	if path in SavedScenes.saved_scenes:
		if ! SavedScenes.saved_scenes[path].dead:
			SavedScenes.saved_scenes[path] = { 
				"position" : object.global_position, 
				"dead": false 
			}
