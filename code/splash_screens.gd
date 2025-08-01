extends Control

var screen_count = 0
var index = 0
@export var next_scene : PackedScene

@onready var screens: Control = $Screens

func _ready() -> void:
	screen_count = screens.get_child_count()

func _on_timer_timeout() -> void:
	next_screen()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		next_screen()

func next_screen() -> void:
	if index < screen_count:
		if index > 0:
			screens.get_child(index - 1).visible = false
		screens.get_child(index).visible = true
	else:
		get_tree().change_scene_to_packed(next_scene)
	index += 1
	$Timer.start()
