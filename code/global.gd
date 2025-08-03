extends Node

const holeObject = preload("res://objects/Hole_Object.tscn") # Hole object

signal score_changed
signal level_changed

var score : int = 0
var high_score : int = 0
var target : int = 10
var level : int = 1

func add_score(additional_score) -> int:
	score += additional_score
	emit_signal("score_changed")
	return score


func set_level(new_level) -> int:
	level = new_level
	emit_signal("level_changed")
	return level
