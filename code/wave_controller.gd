extends Node
var score_target : int = 10
var current_wave_index : int = 0
var current_wave
var spawn_index : int = 0
var enemies_in_wave : int = INF

@onready var timer : Timer = $Timer

const wave_array = [
	{"enemies" : [
		{"type" :"potted_plant", "count" : 10},
		{"type" :"snail", "count" : 10}],
	"bonus" : 25,
	"score_target" : 100}
]

func _ready() -> void:
	# load first round
	load_wave()


func _on_score_changed(new_score) -> void:
	if new_score >= score_target:
		current_wave_index += 1
		# award wave completion bonus
		Global.score += current_wave["bonus"]
		load_wave()

func load_wave():

	# load wave list
	current_wave = wave_array[current_wave_index]
	# start spawning
	spawn_index = 0
	enemies_in_wave = current_wave["enemies"].size()
	print("Enemies in wave: " + str(enemies_in_wave))
	timer.start()


func _on_timer_timeout() -> void:
	if spawn_index < enemies_in_wave:
		spawn_enemy(current_wave["enemies"][spawn_index]["type"])
	else:
		print("Finished spawning wave.")


func spawn_enemy(enemy_type) -> void:
	print("Spawning enemy: " + enemy_type)
	var enemy = load("res://scenes/enemies/" + enemy_type +".tscn").instantiate()
	get_tree().root.add_child(enemy) # is this the proper way of doing things?
	spawn_index += 1
	timer.start()
