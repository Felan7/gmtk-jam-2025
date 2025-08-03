extends Control

@export var start_scene : PackedScene
@export var menu_scene : PackedScene


func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_retry_pressed() -> void:
	get_tree().change_scene_to_packed(start_scene)


func _on_button_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(menu_scene)

func _ready() -> void:
	$CenterContainer/VBoxContainer/Label_Score.text = "Score: " + str(Global.score)
	if Global.score > Global.high_score:
		Global.high_score = Global.score
		$CenterContainer/VBoxContainer/Label_NewHighScore.visible = true
	$CenterContainer/VBoxContainer/Label_HighScore.text = "High Score: " + str(Global.high_score)
