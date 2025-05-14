extends AudioStreamPlayer2D

class_name CharacterSoundFX

enum Sound {
	WALK, HIT, SELECT, CONFIRM, CANCEL, CHOP1, CHOP2, FALLING_TREE, MINING,
	COLLECT, PUSH, POPUP, CATCH
}

var walk_sound : String = "res://Sounds/SoundFX/walk_sound.wav"
var hit_sound : String = "res://Sounds/SoundFX/hit sound.wav"
var select_sound : String = "res://Sounds/SoundFX/select_sound.wav"
var chop1 : String = "res://Sounds/SoundFX/chop tree 1.wav"
var chop2 : String = "res://Sounds/SoundFX/chop tree 2.wav"
var falling_tree : String = "res://Sounds/SoundFX/tree falling.wav"
var mining_stone : String = "res://Sounds/SoundFX/mining_sound.wav"
var collect_sound : String = "res://Sounds/SoundFX/collect_item.wav"
var push : String = "res://Sounds/SoundFX/push_sfx.wav"
var pop_up : String = "res://Sounds/SoundFX/pop_up_sfx.wav"
var catch : String = "res://Sounds/SoundFX/catch_animal.wav"

func play_sound(sound_name: int):
	match sound_name:
		Sound.WALK:
			set_and_play(load(walk_sound))
		Sound.HIT:
			set_and_play(load(hit_sound))
		Sound.CHOP1:
			set_and_play(load(chop1))
		Sound.CHOP2:
			set_and_play(load(chop2))
		Sound.FALLING_TREE:
			set_and_play(load(falling_tree))
		Sound.MINING:
			set_and_play(load(mining_stone))
		Sound.PUSH:
			set_and_play(load(push))
		Sound.POPUP:
			set_and_play(load(pop_up), 3.0)
		Sound.CATCH:
			set_and_play(load(catch))

func set_and_play(_sound: AudioStream, volume_option: float = 0.0):
	set_stream(_sound)
	volume_db = 0.0
	if volume_option != 0.0:
		volume_db += volume_option
	play()
