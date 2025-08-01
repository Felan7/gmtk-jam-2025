extends Control

@export var start_scene : PackedScene

func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_scene)
