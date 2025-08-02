extends CharacterBody2D
# Player character // "Spinner"

# Logic
# - Can move around (does it have momentum? probably should a bit?)
# - Toggle (input?) to start creating a line
# - Can die

var SPEED : float = 300
#var drawing_line_array : Array[Vector2] = []
var isDrawing : bool = false
var previous_location : Vector2 = Vector2.ZERO
var draw_rate : int = 30
var delta_counter : float = 0

func _physics_process(delta: float) -> void:
	position = get_global_mouse_position()
	movement_handler(delta)
	visual_handler()
	queue_redraw()
	
		
func movement_handler(delta): # Handles movement
	var input_velocity : Vector2 = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	velocity = input_velocity.normalized() * SPEED * delta
	move_and_collide(velocity)
	
	if Input.is_action_pressed("input_draw_line"):
		if not isDrawing:
			get_tree().get_first_node_in_group("LineDrawer")._clear_lines()
		isDrawing = true
		#print(previous_location.distance_to(global_position))
		
		if delta_counter < 1:
			delta_counter += delta / (draw_rate / 60)
		else:
			delta_counter = 0
			if previous_location.distance_to(global_position) > 5:
				previous_location = global_position
				get_tree().get_first_node_in_group("LineDrawer").drawing_line_array.append(global_position)
	if Input.is_action_just_released("input_draw_line"):
		isDrawing = false
		AudioMaster.play_audio("8bit_bossa")
	

func visual_handler(): # Handles visual effects and animations
	
	pass

func _destroy(): # Character dies, might trigger special behaviour
	queue_free()
