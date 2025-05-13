extends CharacterBody2D

class_name CharacterSelectLevel

@export var speed : float = 10.0
@export var audio : CharacterSoundFX
var character_controller : CharacterController
var facing_direction : Vector2 = Vector2.ZERO
var original_pitch : float = 0.65

func _ready() -> void:
	# Look down
	facing_direction = Vector2(0, 1)

func _process(delta: float) -> void:
	character_controller = CharacterController.new()
	character_controller.movement_free(self, delta)
	move_and_slide()

# Make audio dynamically
func adjust_random_pitch():
	if !audio: return
	var pitch_range : float = 0.1
	var pitch = randf_range(-pitch_range, pitch_range)
	audio.pitch_scale = original_pitch
	audio.pitch_scale += pitch
	
