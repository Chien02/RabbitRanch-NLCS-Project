extends CharacterBody2D

class_name CharacterSelectLevel

@export var speed : float = 10.0
@export var audio : CharacterSoundFX
var character_controller : CharacterController
var facing_direction : Vector2 = Vector2.ZERO

func _ready() -> void:
	# Look down
	facing_direction = Vector2(0, 1)

func _process(delta: float) -> void:
	character_controller = CharacterController.new()
	character_controller.movement_free(self, delta)
	move_and_slide()
