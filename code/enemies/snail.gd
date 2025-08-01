extends Enemy

var player_is_in_reach : bool = false
var player :CharacterBody2D = null

var speed = 20

func _physics_process(delta: float) -> void:
	if player_is_in_reach:
		velocity = Vector2.ZERO
		if player:
			velocity = position.direction_to(player.position) * speed
		move_and_slide()


func _on_vison_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_is_in_reach = true
		player = body


func _on_vison_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_is_in_reach = false
		player = null
