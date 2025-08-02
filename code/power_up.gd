extends Node2D
class_name PowerUp

var type : String = ""

func collected() -> void:
	print("Collected power up " + type)
