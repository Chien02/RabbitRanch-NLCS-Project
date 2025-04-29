extends Area2D

class_name PlayerDetecter

@onready var collider : CollisionShape2D = get_child(0)
@onready var character : MainCharacter = get_parent()


func _on_body_entered(body: Node2D) -> void:
	if body is Chest:
		body.openable_chest(true, character)
