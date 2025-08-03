extends Area2D
# HoleObject

var isActive : bool = false
var hole_points : Array[Vector2] = []
var appearing_time : float = 0.25

func create_hole(array_data : PackedVector2Array): # Creates a hole object
	for point in array_data:
		hole_points.append(point)
	$CollisionPolygon2D.polygon = array_data
	$CollisionPolygon2D/Polygon2D.polygon = array_data
	$CollisionPolygon2D/Polygon2D/Line2D.points = array_data
	activate_hole()

func _ready() -> void:
	$CollisionPolygon2D/Polygon2D.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	$SfxrStreamPlayer2D.pitch_scale = randf_range(0.6, 1.5)
	print("MY POS: ", global_position)
	var transparency_tween = create_tween()
	transparency_tween.tween_property($CollisionPolygon2D/Polygon2D, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), appearing_time)
	await get_tree().create_timer(appearing_time).timeout
	$CollisionPolygon2D.disabled = false
	await get_tree().create_timer(0.33).timeout
	collision_mask = 53

## Add functionality of "hole creation" where it has that 1 second section where hole appears and after that it becomes active
func activate_hole():

	pass
## Add functionality where an object enters this "hole". It just tells the object "you stepped into a hole
# INSERT SIGNAL


func _on_body_entered(body: Node2D) -> void:
	print("body: ", body.name)
	if body.is_in_group("Enemies") and body.has_method("die"):
		print("HOL: ", hole_points)
		body.fall_into_hole(calculate_center(hole_points))
		body.die()
	if body.is_in_group("Player") and body.has_method("die"):
		print("PLAYE DIE")
		body.die()


func calculate_center(point_array : Array) -> Vector2:
	var result : Vector2 = Vector2.ZERO
	var temp : Vector2 = Vector2.ZERO
	for v in range(point_array.size()):
		temp += point_array[v]
	result = temp / point_array.size()
	print("P: ", temp, "/", result)
	return result
