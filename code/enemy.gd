extends CharacterBody2D
class_name Enemy

var score_points = 1
@onready var sprite = $AnimatedSprite2D

var score_text_animation_scene : PackedScene = preload("res://scenes/menu/score_text_animation.tscn")



func _ready() -> void:
	pass
	# move out of view
	position = create_random_position(get_tree().get_first_node_in_group("Player").position, 50)


func create_random_position(player_position : Vector2, player_view_distance) -> Vector2 :
	const MAX_X = 1080
	const MAX_Y = 1080
	const MIN_X = 0.0
	const MIN_Y = 0.0

	var random_position = Vector2(
		randf_range(MIN_X, MAX_X),
		randf_range(MIN_Y, MAX_Y)
	)
	if player_position.distance_to(random_position) < player_view_distance:
		# move along
		#var lacking_distance = player_view_distance - player_position.distance_to(random_position)
		#move_toward()
		#
		## check if out of bounds
		#if random_position.x > MAX_X or random_position.x < MIN_X or random_position.y > MAX_Y or random_position.y < MIN_Y:
			# try again
			return create_random_position(player_position, player_view_distance)
	return random_position


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
