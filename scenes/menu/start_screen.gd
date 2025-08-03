extends MarginContainer


func _on_button_next_pressed() -> void:
	$Container_Story.visible = false
	$Container_Controls.visible = true


func _on_button_start_pressed() -> void:
	queue_free()
