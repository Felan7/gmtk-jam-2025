extends Node2D
# WORLD

@onready var camera_2d: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player


func _process(delta: float) -> void:
	camera_2d.global_position = player.global_position
