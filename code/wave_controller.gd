extends Node
var score_target : int = 0
var current_wave_index : int = 0
var current_wave
var spawn_index : int = 0
var enemies_in_wave : int = INF

@onready var timer : Timer = $Timer

const wave_array = [
	{"enemies" : [
		{"type" :"cat", "count" : 10},
		{"type" :"brown_cat", "count" : 10},
		{"type" :"chocolate_cat", "count" : 10},
		{"type" :"white_cat", "count" : 10}],
	"bonus" : 25,
	"score_target" : 10},
	{"enemies" : [
		{"type" :"potted_plant", "count" : 10},
		{"type" :"snail", "count" : 10},
		{"type" :"squirrel", "count" : 10}],
	"bonus" : 25,
	"score_target" : 10},
	{"enemies" : [
		{"type" :"squirrel", "count" : 10},
		{"type" :"squirrel", "count" : 10},
		{"type" :"squirrel", "count" : 10}],
	"bonus" : 25,
	"score_target" : 10},
	{"enemies" : [
		{"type" :"cat", "count" : 30},
		],
	"bonus" : 25,
	"score_target" : 10}
]

func _ready() -> void:
	# load first round
	Global.connect("score_changed", _on_score_changed)
	load_wave()


func _on_score_changed() -> void:
	print("Score has changed. Is now: " + str(Global.score) + "/" + str(score_target))
	if Global.score >= score_target:
		current_wave_index += 1
		print("Now wave: " + str(current_wave_index))
		# award wave completion bonus
		Global.score += current_wave["bonus"]
		load_wave()
		Global.set_level(current_wave_index)

func load_wave():
	if current_wave_index == wave_array.size():
		# you beat all the waves, yay
		current_wave_index -= 1

	# load wave list
	current_wave = wave_array[current_wave_index]
	# start spawning
	spawn_index = 0
	enemies_in_wave = current_wave["enemies"].size()
	print("Enemies in wave: " + str(enemies_in_wave))

	score_target += current_wave["score_target"]
	Global.target = score_target

	timer.start()


func _on_timer_timeout() -> void:
	if spawn_index < enemies_in_wave:
		spawn_enemy(current_wave["enemies"][spawn_index]["type"],current_wave["enemies"][spawn_index]["count"])
	else:
		print("Finished spawning wave.")

func spawn_enemy(enemy_type, times) -> void:
	for i in range(0, times):
		print("Spawning enemy: " + enemy_type + " Nr. " + str(i))
		var enemy = load("res://scenes/enemies/" + enemy_type +".tscn").instantiate()
		get_tree().root.add_child(enemy) # is this the proper way of doing things?
		await get_tree().create_timer(0.1).timeout
	spawn_index += 1
	timer.start()
