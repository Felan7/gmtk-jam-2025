extends Node
## AUDIO MASTER // AUTO-LOAD
# - Handles audio playback

const audioPlayer = preload("res://objects/audio_stream_player.tscn")
var frame_incrementer : int = 0 # Used for giving audio unique identifiers

var audio_MASTER_volume : int = 50
var audio_MUSIC_volume : int = 50
var audio_SFX_volume : int = 50


# NOTE (s)
# - When setting audio to loop, don't set it in import settings. We manually set it to loop based on the "looping" bool in the audio_list!
# - Also, it's easier to add "volume_adjust" here than manually change volume of the file itself. Remember to test the audio volumes first!
# Audio_busses: "Master", "MUSIC", "SFX" (Master  is only one that is not capitalized)

var audio_list = { # Contains all audio files. Use the following order ["preload path", "type", "looping?", "volume adjust"]
	"8bit_bossa": [preload("res://assets/audio/8bit Bossa.mp3"), "MUSIC", true, -6.0],
	
	# example > name: [preload(<PATH>), "Master", loop : bool, volume_adjust : float]
}

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_end"):
		print(">>>DEBUG INPUT, Shift+End => Killing all audio!")
		kill_audio()
	update_audio_volume_bus()

func update_audio_volume_bus():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(audio_MASTER_volume / 100.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MUSIC"), linear_to_db(audio_MUSIC_volume / 100.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(audio_SFX_volume / 100.0))

func play_audio(audio_name): ## Plays audio
	if audio_list.has(audio_name): # If we have audio with that name in the audio_list
		frame_incrementer += 1
		var newAudioPlayer = audioPlayer.instantiate()
		newAudioPlayer.initialize(audio_list[audio_name][0], audio_list[audio_name][1], audio_list[audio_name][2], audio_list[audio_name][3])
		match audio_list[audio_name][1]:
			"Master":
				$MASTER.add_child(newAudioPlayer)
			"MUSIC":
				$MUSIC.add_child(newAudioPlayer)
			"SFX":
				$SFX.add_child(newAudioPlayer)
			_:
				print("Received audio bus ", audio_list[audio_name][1], " was not recognized. Possible typo?")
				$MASTER.add_child(newAudioPlayer)
		newAudioPlayer.name = str(audio_name, "_", frame_incrementer)
		newAudioPlayer.play_audio()
	else:
		print("Audio ", audio_name, " was not found. Did you write the name correctly?")

func kill_audio(bus_type : String = ""): # Kill all audio from specific bus. If not specified, kills ALL audio
	var audio_to_kill = []
	match bus_type:
		"Master":
			audio_to_kill.append_array(get_tree().get_nodes_in_group("audio_master"))
		"MUSIC":
			audio_to_kill.append_array(get_tree().get_nodes_in_group("audio_music"))
		"SFX":
			audio_to_kill.append_array(get_tree().get_nodes_in_group("audio_sfx"))
		"":
			audio_to_kill.append_array(get_tree().get_nodes_in_group("audio"))
	for audio_node in audio_to_kill:
		audio_node._destroy()
