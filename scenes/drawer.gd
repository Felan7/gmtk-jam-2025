extends Node2D
# line drawing object - test
var drawing_line_array : Array[Vector2] = []
var previous_size : int = 0
var perma_dots : Array[Vector2] = []
var length : float = 0
var max_line_length = 520
var holes : Dictionary  = {}


func _physics_process(_delta: float) -> void:
	$Label.text = str("Line length: ", snappedf(length, 0.1))
	if drawing_line_array.size() > 0:
		queue_redraw()
	if length > max_line_length:
		for deletion in range(floor(length / max_line_length)):
			drawing_line_array.pop_front()
	calculate_length()
	#print(length)#drawing_line_array.size())
	if previous_size != drawing_line_array.size():
		calculate_intersections()
	previous_size = drawing_line_array.size()

func _clear_lines():
	drawing_line_array.clear()
	perma_dots.clear()

func _draw() -> void:
	for dot_pos in range(drawing_line_array.size() - 1):
		draw_line(drawing_line_array[dot_pos], drawing_line_array[dot_pos + 1], Color.RED, 3)
	for dot_B in range(perma_dots.size() - 1):
		draw_line(perma_dots[dot_B], perma_dots[dot_B + 1], Color.BLUE, 8)
	
	
	for hole_names in holes.keys():
		var hole_candinate = holes[hole_names]
		for data_pos in range(hole_candinate.size() - 1):
			draw_line(hole_candinate[data_pos], hole_candinate[data_pos + 1], Color.PURPLE, 6)
		draw_line(hole_candinate[0], hole_candinate[hole_candinate.size() - 1], Color.PURPLE, 6)
	
func calculate_length():
	length = 0
	for dot_pos in range(drawing_line_array.size()):
		if dot_pos != 0 and dot_pos != (drawing_line_array.size() - 1):
			length += drawing_line_array[dot_pos].distance_to(drawing_line_array[dot_pos + 1])

func calculate_intersections(): # Calculates if last drawn line intersects with any previous line
	# We want to compare last line with previous lines
	# - No point comparing neighbour lines as neighbours cannot intersect
	# - if finds an intersection -> SAVE "newest" point pair (remember starter point)
	# 	= AND pick the other intersecting point, SAVE "last one".
	# - DELETE ALL POINTS BEFORE LAST ONE and AFTER "newest"
	# Add newly found "circle dots" into different array that contains holes
	
	var isIntersecting : bool = false
	var circle_start_pos : int = 0
	var circle_end_pos : int = 0
	
	var positions = drawing_line_array # Save positions for local use
	for i in range(positions.size() - 1): # Go through all points from oldest first
		var break_out = false
		# pair A
		var p1 = positions[i] 
		var p2 = positions[i + 1] # Point pair A
		
		for j in range(positions.size() - 2, positions.size() - 1):
			# pair B
			var p3 = positions[j]
			var p4 = positions[j + 1] # Point pair B
			
			if (p3 != p2 and p3 != p1):
				if are_lines_intersecting(p1, p2, p3, p4):
					isIntersecting = true
					circle_start_pos = i + 1
					circle_end_pos = j
					break
		if break_out:
			break
	
	if isIntersecting: 
		var temp_hole : Array[Vector2]
		# Gets the first point where lines intersect and adds it to the array
		temp_hole.append(
			Geometry2D.get_closest_point_to_segment(
				drawing_line_array[circle_end_pos], drawing_line_array[circle_start_pos - 1], drawing_line_array[circle_start_pos]))
		for linePoints in range(circle_start_pos + 1, circle_end_pos): # Adds remaining points all the way to the newest point
			temp_hole.append(drawing_line_array[linePoints])
			
		var new_hole = Global.holeObject.instantiate()
		$"../HOLES".add_child(new_hole)
		new_hole.create_hole(temp_hole)
		_clear_lines()

func are_lines_intersecting(a : Vector2, b : Vector2, c : Vector2, d : Vector2):
	var denominator : float = ((b.x - a.x) * (d.y - c.y)) - ((b.y - a.y) * (d.x - c.x))
	var numerator1 : float = ((a.y - c.y) * (d.x - c.x)) - ((a.x - c.x) * (d.y - c.y))
	var numerator2 : float = ((a.y - c.y) * (b.x - a.x)) - ((a.x - c.x) * (b.y - a.y))
	
	if denominator == 0:
		return numerator1 == 0 && numerator2 == 0
	var r = numerator1 / denominator
	var s = numerator2 / denominator
		
	return (r >= 0 && r <= 1) && (s >= 0 && s <= 1)
	
