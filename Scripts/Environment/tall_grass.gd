extends EnvironmentObject

class_name TallGrass

@export var animation_tree : AnimationTree
@onready var grid : Grid = get_tree().get_first_node_in_group("Grid")
var local_position : Vector2i = Vector2i.ZERO
var root : TallGrass
var visited : bool = false

signal AnimalEntered
signal AnimalExited
signal PlayerEntered
signal PlayerExited

func _ready() -> void:
	if grid: local_position = grid.local_to_map(position)

func _on_area_2d_body_entered(body: Node2D) -> void:
	waving()
	if body is not Character: return
	if body is Animal: AnimalEntered.emit(body, local_position)
	elif body is MainCharacter: PlayerEntered.emit(body, local_position)

func _on_area_2d_body_exited(body: Node2D) -> void:
	waving()
	if body is not Character: return
	if body is Animal: AnimalExited.emit(body)
	elif body is MainCharacter: PlayerExited.emit(body)

func waving():
	animation_tree["parameters/conditions/is_waving"] = true
	animation_tree["parameters/conditions/is_not_waving"] = false

func stop_waving():
	animation_tree["parameters/conditions/is_waving"] = false
	animation_tree["parameters/conditions/is_not_waving"] = true
