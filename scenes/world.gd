extends Node2D
# WORLD

@onready var camera_2d: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player

var inputted_key = ""

func _process(_delta: float) -> void:
	if player:
		camera_2d.global_position = player.global_position

func _ready() -> void:
	# $Camera2D/CanvasLayer/GameOverScreen.visible = false # NOTE - Commented out, see reason below
	await get_tree().create_timer(0.25).timeout
	AudioMaster.play_audio("moreWhimsey")

func game_over(): # Commented out since when had file conflict "GameOverScreen" needed to be removed
	#$Camera2D/CanvasLayer/GameOverScreen.visible = true
	#$Camera2D/CanvasLayer/GameOverScreen.score()
	pass
