extends CharacterBody2D
class_name Enemy

var score_points = 1
@onready var sprite = $AnimatedSprite2D

var score_text_animation_scene : PackedScene = preload("res://scenes/menu/score_text_animation.tscn")

@onready var sfx_death = $Sfxr_Death
var enemy_type : String = "" # Enemy type

var is_dying : bool = false
var isPlayerCloseEnough : bool = false
var collidedNodes = []
@export var manualPlacement : bool = false

func _ready() -> void:
	if not manualPlacement and get_tree().get_first_node_in_group("Player"):
		position = create_random_position(get_tree().get_first_node_in_group("Player").position, 300)

func _physics_process(delta: float) -> void:
	if collidedNodes.size() > 0:
		push_entities()

func create_random_position(player_position : Vector2, player_view_distance) -> Vector2 :
	var relocation_needed : bool = false
	const MAX_X = 1024 - 32
	const MAX_Y = 1024 - 32
	const MIN_X = -1024 + 32
	const MIN_Y = -1024 + 32

	var random_position = Vector2(
		randf_range(MIN_X, MAX_X),
		randf_range(MIN_Y, MAX_Y)
	)

	if player_position.distance_to(random_position) < player_view_distance:
		relocation_needed = true
		# move along
		#var lacking_distance = player_view_distance - player_position.distance_to(random_position)
		#move_toward()
		#
		## check if out of bounds
		#if random_position.x > MAX_X or random_position.x < MIN_X or random_position.y > MAX_Y or random_position.y < MIN_Y:
			# try again

	if relocation_needed:
		#print("NEEDED TO RELOCATE CAT")
		return create_random_position(player_position, player_view_distance)
	else:
		return random_position


func die() -> void:
	$Area2D/CollisionShape2D.disabled = true
	if not $VisibleOnScreenNotifier2D.is_on_screen() and global_position.distance_to(get_tree().get_first_node_in_group("Player").global_position) > 320: # When it dies, if it's not on screen, spawn a new one without death sound or score incrementing
		get_tree().get_first_node_in_group("wave_controller").spawn_enemy(enemy_type, 1)
		print("Enemy respawning as got spawn camped at ", global_position)
		queue_free()
	else:
		is_dying = true
		print("Death is upon me says " + str(name))
		sfx_death.pitch_scale = randf_range(0.6,1.5)
		sfx_death.play()

		# dying animation
		sprite.animation = "dying"
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.tween_property(sprite, "scale", Vector2.ZERO, 2)
		tween.tween_property(sprite, "rotation", -10, 2)
		tween.tween_property(sprite, "self_modulate", Color(0.0, 0.0, 0.0, 0.0), 2)
		tween.set_parallel(false)
		tween.tween_callback(queue_free)

		# award score points
		Global.add_score(score_points)

		var score_text_animation = score_text_animation_scene.instantiate()
		score_text_animation.position = position
		score_text_animation.text = "+" + str(score_points)
		get_tree().root.add_child(score_text_animation)

func fall_into_hole(target_pos : Vector2):
	print("target: ", target_pos, " /", global_position)
	var tween_movement = create_tween()
	tween_movement.tween_property(self, "global_position", target_pos, 2).set_trans(Tween.TRANS_QUAD)

func push_entities():
	for node in collidedNodes:
		node.impulse_effect((node.global_position - global_position).normalized(), 1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.has_method("impulse_effect"):
		collidedNodes.append(body)



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		collidedNodes.erase(body)
