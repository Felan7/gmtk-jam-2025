extends Area2D

func isOnHole() -> bool:
	print("BODS: ", get_overlapping_areas())
	if get_overlapping_areas().size() > 0:
		print("OVERLAPPING WITH HOLE, REPOSITIONING!")
		return true
	else:
		return false

func destroy():
	queue_free()
