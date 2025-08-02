extends Node2D

@onready var label = $Label
var text : String = ""

func _ready() -> void:
	# print("Look: " + text)
	label.text = text
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(label, "position:y", -64, 0.5)
	tween.tween_property(label, "modulate:a", 0, 0.25)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
