extends CharacterBody2D

class_name MainCharacter

@export var speed : float = 10.0
@export var grid : Grid

var character_controller : CharacterController

func _ready() -> void:
	character_controller = CharacterController.new()

func _process(delta: float) -> void:
	character_controller.movement(self, delta)
