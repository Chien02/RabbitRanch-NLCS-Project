extends CharacterBody2D

class_name Animal

@export var speed : float = 10.0
@export var grid : Grid
@export var astar : Astar

var turnbase_actor : TurnBaseActor
var character_controller : CharacterController

func _ready() -> void:
	turnbase_actor = TurnBaseActor.new()
	character_controller = CharacterController.new()

func _process(delta: float) -> void:
	if !turnbase_actor.is_active: return
	character_controller.movement(self, delta)
