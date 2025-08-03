extends Control


func _on_button_next_pressed() -> void:
	$MarginContainer/Container_Story.visible = false
	$MarginContainer/Container_Controls.visible = true


func _on_button_start_pressed() -> void:
	queue_free()
