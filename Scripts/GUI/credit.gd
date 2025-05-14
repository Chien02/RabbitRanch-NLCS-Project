extends Control
# Credit.gd
@export var audio : UISoundFX

func _on_back_button_pressed() -> void:
	audio.play_sound(UISoundFX.Sound.SELECT)
	visible = false
