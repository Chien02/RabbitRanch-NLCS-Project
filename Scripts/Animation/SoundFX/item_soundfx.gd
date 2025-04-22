extends CharacterSoundFX

class_name ItemSoundFX

func play_sound(sound_name: int):
	match sound_name:
		Sound.COLLECT:
			set_and_play(load(collect_sound))
