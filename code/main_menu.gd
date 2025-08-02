extends Control
# MainMenu
@export var start_scene : PackedScene
var optionsVisible : bool = false


func _process(delta: float) -> void:
	$OPTIONS.visible = optionsVisible

func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_scene)


func options_stuff():

	pass


func _on_close_button_pressed() -> void: # Close settings menu
	print("PRETENDING OPTIONS MENU HIDING ITSELF!")
	optionsVisible = false


func _on_button_settings_pressed() -> void:
	optionsVisible = true
