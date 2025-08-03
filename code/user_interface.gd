extends Control


@onready var label_score = $MarginContainer/VBoxContainer/Label_Score
@onready var label_level = $MarginContainer/VBoxContainer/HBoxContainer_Progress/Label_Level
@onready var label_target = $MarginContainer/VBoxContainer/HBoxContainer_Progress/Label_Target
@onready var progress_bar = $MarginContainer/VBoxContainer/HBoxContainer_Progress/ProgressBar

var wave : int = 0
var old_target : int = 0
var target : int = 0

func _ready() -> void:
	Global.connect("score_changed", _on_score_changed)
	Global.connect("level_changed", _on_level_changed)
	update_score()
	update_level()

func _on_score_changed():
	update_score()

func update_score() -> void:
	label_score.text = "Score: " + str(Global.score)
	progress_bar.value = Global.score


func update_level() -> void:
	print("updating level")
	wave += 1
	progress_bar.min_value = old_target
	old_target = target
	target = Global.target
	progress_bar.max_value = target
	draw_level()


func draw_level() -> void:
	label_level.text = "Wave: " + str(wave)
	label_target.text = "Target: " + str(Global.target)


func _on_level_changed() -> void:
	update_level()
