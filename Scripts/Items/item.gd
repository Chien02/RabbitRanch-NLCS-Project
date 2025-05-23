extends Node2D

class_name Item

signal Disappear

@onready var grid : Grid = get_tree().get_first_node_in_group("Grid")
@export var resource : ItemResource
@export var collider : CollisionShape2D
@export var audio : ItemSoundFX

var character : MainCharacter = null
var is_in_inventory : bool = false
var is_activating : bool = false

func activating_update(_delta: float) -> void:
	pass

func init(_grid, _character, _resource):
	grid = _grid
	character = _character
	resource = _resource

func set_character(new_owner: MainCharacter):
	character = new_owner

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter:
		print("From Item: collide with Main Character")
	elif body is Animal:
		print("From Item: collide with Animal")

func active():
	print("From ", name, ": is just activated!")

func disappear():
	if collider:
		collider.set_deferred("disabled", true)
	is_activating = false
	await CustomTween.explode(self, resource.duration)
	Disappear.emit()
	queue_free()

func finish_active():
	character.inventory.FinishedUsingItem.emit()
