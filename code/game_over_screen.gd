extends Control

@export var menu_scene : PackedScene


func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_retry_pressed() -> void:
	AudioMaster.kill_audio("")
	get_tree().reload_current_scene()


func _on_button_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(menu_scene)

func score() -> void:

	$CenterContainer/VBoxContainer/Label_Score.text = "Score: " + str(Global.score)
	if Global.score > Global.high_score:
		Global.high_score = Global.score
		$CenterContainer/VBoxContainer/Label_NewHighScore.visible = true
	$CenterContainer/VBoxContainer/Label_HighScore.text = "High Score: " + str(Global.high_score)
	Global.score
