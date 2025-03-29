extends Camera2D

class_name CameraController

@onready var turnbase_manager : TurnBasedManager = get_tree().get_first_node_in_group("TurnBasedManager")
var duration : float = 5

func _ready() -> void:
	offset = Vector2.ZERO

func _process(_delta: float) -> void:
	var direction : Vector2 = (turnbase_manager.current_actor.position - position).normalized()
	var destination = direction * Vector2(10, 10)
	offset = offset.lerp(destination, duration * _delta)
