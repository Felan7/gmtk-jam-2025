extends Node

const holeObject = preload("res://objects/Hole_Object.tscn") # Hole object

signal score_changed

var score : int = 0
var high_score : int = 0

func add_score(additional_score) -> int:
	score += additional_score

	emit_signal("score_changed")
	return score
