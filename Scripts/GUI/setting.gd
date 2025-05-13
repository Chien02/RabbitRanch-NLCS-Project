extends Control

class_name Setting

@export var volume_sliders : Array[HSlider]
@export var audio : UISoundFX
const DEFAULT_VOLUME_VALUE : float = 100.0

func _on_back_button_pressed() -> void:
	audio.play_sound(UISoundFX.Sound.CANCEL)
	visible = false

func _on_reset_button_pressed() -> void:
	audio.play_sound(UISoundFX.Sound.CANCEL)
	for _slider in volume_sliders:
		_slider.value = DEFAULT_VOLUME_VALUE


func _on_visibility_changed() -> void:
	load_volume_config()

func load_volume_config():
	var volume_config = GlobalProperties.get_volume_config()
	for _slider in volume_sliders:
		_slider.value = volume_config[_slider.bus_name]
