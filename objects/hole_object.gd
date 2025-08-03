extends Area2D
# HoleObject

var isActive : bool = false
var points : Array[Vector2] = []

func create_hole(array_data : PackedVector2Array): # Creates a hole object
	$CollisionPolygon2D.polygon = array_data
	$CollisionPolygon2D/Polygon2D.polygon = array_data
	$CollisionPolygon2D/Polygon2D/Line2D.points = array_data
	activate_hole()


## Add functionality of "hole creation" where it has that 1 second section where hole appears and after that it becomes active
func activate_hole():
	
	pass
## Add functionality where an object enters this "hole". It just tells the object "you stepped into a hole
# INSERT SIGNAL


func _on_body_entered(body: Node2D) -> void:
	print("body ", body.name, " entered!")
	if body.is_in_group("Enemies") and body.has_method("die"):
		body.die()
