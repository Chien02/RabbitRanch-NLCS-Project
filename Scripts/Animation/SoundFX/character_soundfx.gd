extends AudioStreamPlayer2D

class_name CharacterSoundFX

enum Sound{
	WALK, HIT, SELECT, COMFIRM, CANCEL, CHOP1, CHOP2, FALLING_TREE, MINING,
	COLLECT
}

var walk_sound : String = "res://Sounds/SoundFX/walk_sound.wav"
var hit_sound : String = "res://Sounds/SoundFX/hit sound.wav"
var select_sound : String = "res://Sounds/SoundFX/select_sound.wav"
var chop1 : String = "res://Sounds/SoundFX/chop tree 1.wav"
var chop2 : String = "res://Sounds/SoundFX/chop tree 2.wav"
var falling_tree : String = "res://Sounds/SoundFX/tree falling.wav"
var mining_stone : String = "res://Sounds/SoundFX/mining_sound.wav"
var collect_sound : String = "res://Sounds/SoundFX/collect_item.wav"

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

func set_and_play(_sound: AudioStreamWAV):
	set_stream(_sound)
	play()
