extends CharacterBody2D
class_name Enemy

var score_points = 1
@onready var sprite = $AnimatedSprite2D

var score_text_animation_scene : PackedScene = preload("res://scenes/menu/score_text_animation.tscn")

func _ready() -> void:
	pass
	# move out of view

func die() -> void:
	print("Death is upon me says " + str(name))

	# dying animation
	sprite.animation = "dying"
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(sprite, "scale", Vector2.ZERO, 2)
	tween.tween_property(sprite, "rotation", -10, 2)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)

	# award score points
	Global.add_score(score_points)

	var score_text_animation = score_text_animation_scene.instantiate()
	score_text_animation.position = position
	score_text_animation.text = "+" + str(score_points)
	get_tree().root.add_child(score_text_animation)
