extends Node2D
# WORLD

@onready var camera_2d: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player


func _process(_delta: float) -> void:
	camera_2d.global_position = player.global_position

func _ready() -> void:
	await get_tree().create_timer(0.25).timeout
	AudioMaster.play_audio("moreWhimsey")

func _dev_spawn_enemies():
	var enemy_list = ["cat", "plant", "snail", "squirrel"]
	var spawn_location = player.global_position + Vector2(100, 00).rotated(deg_to_rad(randi_range(0, 360)))
	var cats = {
		"cat": ["cat", "brown_cat", "chocolate_cat", "white_cat"],
		"snail": ["snail"],
		"plant": ["potted_plant"],
		"squirrel": ["squirrel"]
	}

	for a in range(10):
		#$WaveController.spawn_enemy()
		pass
