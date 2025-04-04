extends Node2D

class_name Item

signal Disappear

@onready var grid : Grid = get_tree().get_first_node_in_group("Grid")
@export var resource : ItemResource
var character : MainCharacter = null
var is_activating : bool = false

func init(_grid, _character, _resource):
	grid = _grid
	character = _character
	resource = _resource

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter:
		print("From Item: collide with Main Character")
	elif body is Animal:
		print("From Item: collide with Animal")

func active():
	print("From ", resource.name, ": is just activated!")

func disappear():
	await CustomTween.explode(self, resource.duration)
	Disappear.emit()
	queue_free()
