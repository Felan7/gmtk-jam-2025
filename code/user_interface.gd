extends Control


@onready var label_score = $MarginContainer/VBoxContainer/Label_Score
@onready var label_level = $MarginContainer/VBoxContainer/HBoxContainer_Progress/Label_Level
@onready var label_target = $MarginContainer/VBoxContainer/HBoxContainer_Progress/Label_Target
@onready var progress_bar = $MarginContainer/VBoxContainer/HBoxContainer_Progress/ProgressBar

func _ready() -> void:
	Global.connect("score_changed", _on_score_changed)
	Global.connect("level_changed", _on_level_changed)
	update_score()

func _on_score_changed():
	update_score()

func update_score() -> void:
	label_score.text = str(Global.score)
	progress_bar.value = Global.score


func update_level() -> void:
	var level = 1
	var target = Global.target
	label_level.text = str(level)
	label_target.text = str(target)
	progress_bar.min_value = progress_bar.max_value
	progress_bar.max_value = target

func _on_level_changed() -> void:
	update_level()
