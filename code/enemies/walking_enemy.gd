extends Enemy
class_name WalkingEnemy

var player_is_in_reach : bool = false
var player :CharacterBody2D = null

var speed = 80



func _physics_process(_delta: float) -> void:
	if collidedNodes.size() > 0:
		push_entities()
	if player_is_in_reach:
		velocity = Vector2.ZERO
		if player and not is_dying:
			velocity = position.direction_to(player.position) * speed
			if player.position.x > position.x:
				$AnimatedSprite2D.flip_h = false
			if player.position.x < position.x:
				$AnimatedSprite2D.flip_h = true
		move_and_slide()


func _on_vison_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_is_in_reach = true
		player = body
		sprite.animation = "moving"


func _on_vison_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_is_in_reach = false
		player = null
		sprite.animation = "idle"
