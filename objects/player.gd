extends CharacterBody2D
# Player character // "Spinner"

# Logic
# - Can move around (does it have momentum? probably should a bit?)
# - Toggle (input?) to start creating a line
# - Can die

# --- Player variables --- #
var SPEED : float = 180 # How fast player character moves
var ACCELERATION : float = 0.4 # How quickly player accelerates
var DEACCELERATION : float = 0.8 # How quickly player slows down


var isDrawing : bool = false # Is player currently drawing a line
var previous_location : Vector2 = Vector2.ZERO
var draw_rate : int = 10
var prev_player_pos : Vector2 = Vector2.ZERO
var deploy_counter : float = 0
var point_arr = []
var player_perceived_speed : float = 0 # Player perceived speed

var mouse_control : bool = false

@onready var sfx_cutting: AudioStreamPlayer2D = $SfxrStreamPlayer2D


func _ready() -> void:
	#$AnimationPlayer.play("rotate")
	pass

func _physics_process(delta: float) -> void:
	if mouse_control:
		position = get_global_mouse_position()

	particles.emitting = false
	movement_handler(delta)
	visual_handler()
	queue_redraw()

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var sprite: AnimatedSprite2D = $Sprite


func movement_handler(delta): # Handles movement
	var input_velocity : Vector2 = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	#print(input_velocity)
	particles.direction = Vector2(input_velocity.x * -1.0, input_velocity.y * -1.0)

	if input_velocity.x > 0:
		sprite.animation = "moving_side"
		sprite.flip_h = false
		sprite.position.x = 0.0
	elif input_velocity.x < 0:
		sprite.animation = "moving_side"
		sprite.flip_h = true
		sprite.position.x = 16.0
	elif input_velocity.y < 0:
		sprite.animation = "moving_up"
		sprite.flip_h = false
		sprite.position.x = 0.0
	elif input_velocity.y > 0:
		sprite.animation = "moving_down"
		sprite.flip_h = false
		sprite.position.x = 0.0

	if input_velocity.length() > 0:
		velocity = lerp(velocity, input_velocity.normalized() * SPEED * delta, 0.1)
		if isDrawing:
			particles.emitting = true
			sfx_cutting.playing = true

	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.1)
		sfx_cutting.playing = false



	move_and_collide(velocity)

	player_perceived_speed = (prev_player_pos - global_position).length()
	$Label.text = str("SPEED: ", snappedf(player_perceived_speed, 0.1))
	prev_player_pos = global_position

	if Input.is_action_pressed("input_draw_line"):
		if not isDrawing:
			get_tree().get_first_node_in_group("LineDrawer")._clear_lines()
		isDrawing = true


	if Input.is_action_just_released("input_draw_line"):
		isDrawing = false

		#AudioMaster.play_audio("8bit_bossa")

	## Maybe make making dots happen on process and drawing/update speed depends on character speed? (faster movement, more frequent updates?)

func _process(delta: float) -> void:
	if isDrawing and player_perceived_speed > 1:
		var comparison_value = 1 / (24 + pow(player_perceived_speed, 1.1)) # Good enough, might have problems if moves too fast, but technically not possible?
		if deploy_counter < comparison_value: # How frequently does player place points down
			deploy_counter += delta
		else:
			deploy_counter = 0
			point_arr.append(global_position) # Debug array // remove later?
			get_tree().get_first_node_in_group("LineDrawer").drawing_line_array.append(global_position) # Add player position to the line drawn array
			#queue_redraw()
	else:
		point_arr.clear()
"""
func _draw() -> void: # Debug circles
	for dot in point_arr:
		draw_circle(dot - global_position, 4, Color.RED, false)
"""
func visual_handler(): # Handles visual effects and animations

	pass

func _destroy(): # Character dies, might trigger special behaviour
	queue_free()

func die():
	_destroy()
	get_parent().game_over()
