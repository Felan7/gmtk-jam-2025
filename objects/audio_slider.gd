@tool
extends HBoxContainer
# Audio_Slider-object
var slider_value : int = 50
var previous_value : int = 0
@export_enum("MASTER", "MUSIC", "SFX") var bus_type : String = "MASTER"

func _ready() -> void:
	$HSlider.value = slider_value

func _on_h_slider_drag_started() -> void:
	pass # Replace with function body.
	
func _on_h_slider_drag_ended(_value_changed: bool) -> void:
	slider_value = $HSlider.value
	$HSlider.release_focus() # When we finish moving slider, release focus so we don't accidentally change it more

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$AUDIO_BUS_NAME.text = bus_type
	else:
		# Update audio volumes in "AudioMaster"
		if previous_value != slider_value:
			match bus_type:
				"MASTER":
					AudioMaster.audio_MASTER_volume = slider_value
				"MUSIC":
					AudioMaster.audio_MUSIC_volume = slider_value
				"SFX":
					AudioMaster.audio_SFX_volume = slider_value
		previous_value = slider_value
	update_visuals()
	
func update_visuals():
	$AUDIO_BUS_NAME.text = bus_type
	slider_value = $HSlider.value
	$VALUE.text = str(slider_value)
