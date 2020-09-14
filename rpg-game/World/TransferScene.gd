extends Area2D

export(String) var target_scene;
export(String) var target_locator;

func _on_Area2D_body_entered(_body):
	PlayerStats.target_locator = target_locator
	get_tree().change_scene(target_scene)
