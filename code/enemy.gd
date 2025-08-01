extends CharacterBody2D
class_name Enemy

var score_points = 1

func _ready() -> void:
	pass
	# move out of view

func die() -> void:
	# award score points
	print("Death is upon me")
	Global.score += score_points
	Global.emit_signal("score_changed")
	queue_free()
