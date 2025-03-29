extends Node2D

class_name Item

@onready var grid : Grid = get_tree().get_first_node_in_group("Grid")
@onready var character : MainCharacter = get_tree().get_first_node_in_group("MainCharacter")

@export var duration : float = 0.5
@export var resource : ItemResource

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter:
		print("From Item: collide with Main Character")
	elif body is Animal:
		print("From Item: collide with Animal")

func active():
	print("From ", str(name).to_lower(), ": is just activated!")

func disappear():
	await CustomTween.explode(self, duration)
	queue_free()
