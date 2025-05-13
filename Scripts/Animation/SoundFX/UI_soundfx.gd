extends CharacterSoundFX

class_name UISoundFX

var select_sound_path : String = "res://Sounds/SoundFX/select_sound.wav"
var comfirm_sound : String = "res://Sounds/SoundFX/confirm.wav"
var cancel_sound : String = "res://Sounds/SoundFX/cancel.wav"


func play_sound(sound_id: int):
	match sound_id:
		Sound.SELECT:
			set_and_play(load(select_sound_path), 3.0)
		Sound.CONFIRM:
			set_and_play(load(comfirm_sound), 2.0)
		Sound.CANCEL:
			set_and_play(load(cancel_sound), 4.0)
