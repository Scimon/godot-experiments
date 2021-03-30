extends PanelContainer

const OFFSET := Vector2(25, -25)

var current_entity: Node

onready var label := $MarginContainer/Label

func _ready() -> void:
	set_as_toplevel(true)
	
	Events.connect("hovered_over_entity", self, "_on_hovered_over_entity")
	Events.connect("info_updated", self, "_on_info_updated")
	hide()

func _process(delta: float) -> void:
	rect_global_position = get_global_mouse_position() + OFFSET
	
func _set_info(entity: Node) -> void:
	var entity_filename: String = Library.get_entity_name_from(entity).capitalize()
	var output := entity_filename
	
	if entity is BlueprintEntity:
		output += "\n%s" % entity.description
	else:
		if entity.has_method("get_info"):
			var info: String = entity.get_info()
			if not info.empty():
				output += "\n%s" % info
	label.text = output
	show()

func _on_hovered_over_entity(entity: Node) -> void:
	if not entity == current_entity:
		current_entity = entity
	if not entity:
		label.text = ""
		hide()
	else:
		_set_info(entity)
		set_deferred("rect_size", Vector2.ZERO)

func _on_info_updated(entity: Node) -> void:
	if current_entity and entity == current_entity:
		_set_info(current_entity)
		set_deferred("rect_size", Vector2.ZERO)
