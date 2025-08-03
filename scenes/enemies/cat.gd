extends Enemy

var player_is_in_reach : bool = false
var player :CharacterBody2D = null

var speed = 80

func _physics_process(_delta: float) -> void:
	if player:
			velocity = position.direction_to(player.position) * speed
			if player.position.x > position.x:
				$AnimatedSprite2D.flip_h = false
			if player.position.x < position.x:
				$AnimatedSprite2D.flip_h = true
	if player_is_in_reach:
		velocity = Vector2.ZERO
		if player and not is_dying:
			velocity = position.direction_to(player.position) * speed


		move_and_slide()


func _on_vison_area_2d_body_entered(body: Node2D) -> void:
	print("meow enter")
	if body.is_in_group("Player"):

		player = body
		sprite.animation = "prowl"


func _on_vison_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_is_in_reach = false
		player = null
		sprite.animation = "scout"


func _on_pounce_area_2d_body_entered(_body: Node2D) -> void:
	player_is_in_reach = true
	sprite.animation = "pounce"
