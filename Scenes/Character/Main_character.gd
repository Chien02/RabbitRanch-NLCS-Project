extends CharacterBody2D

class_name MainCharacter

@export var speed : float = 10.0
@export var grid : Grid
var turnbase_actor : TurnBaseActor

var character_controller : CharacterController

func _ready() -> void:
	character_controller = CharacterController.new()
	turnbase_actor = TurnBaseActor.new()

func _process(delta: float) -> void:
	if !turnbase_actor.is_active: return
	character_controller.movement(self, delta)
