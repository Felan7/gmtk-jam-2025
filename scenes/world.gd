extends Node2D
# WORLD

@onready var camera_2d: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player

var inputted_key = ""

func _process(_delta: float) -> void:
	if player:
		camera_2d.global_position = player.global_position

func _ready() -> void:
	$Camera2D/CanvasLayer/GameOverScreen.visible = false
	await get_tree().create_timer(0.25).timeout
	AudioMaster.play_audio("moreWhimsey")

func game_over():
	$Camera2D/CanvasLayer/GameOverScreen.visible = true
