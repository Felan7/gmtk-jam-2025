extends AudioStreamPlayer

var isLooping : bool = false

func initialize(audio_file : AudioStream, bus_type : String, looping : bool, volume_offset : float) -> void:
	# Initialize audioplayer with data. Must be manually called!
	stream = audio_file
	match bus_type:
		"Master":
			bus = "Master"
			add_to_group("audio_master")
		"MUSIC":
			bus = "MUSIC"
			add_to_group("audio_music")
		"SFX":
			bus = "SFX"
			add_to_group("audio_sfx")
		_:
			print("Received bus name ", bus_type, " which was incorrect.")
			bus = "Master"
			add_to_group("audio_master")
			
	isLooping = looping
	volume_db = volume_offset

func play_audio(): # Need to separately trigger play audio as node is not yet in the tree
	play(0.0)

func _destroy(): # Destroy the object
	print(name, " destroyed!")
	queue_free()

func _on_finished() -> void:
	if not isLooping:
		_destroy()
	else:
		play_audio()
		print(str(name, " Looping!"))
