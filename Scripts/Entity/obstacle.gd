extends RigidBody2D

class_name Obstacle

var grid : Grid
var pushable_direction : Array[Vector2i] = []
var characterController : CharacterController
var global_spawn
var local_spawn

func _ready() -> void:
	characterController = CharacterController.new()
	global_position = global_spawn

func reset():
	pushable_direction.clear()

func init_pushable_diretion():
	reset()
	var pos = grid.local_to_map(position)
	var temp_array = grid.get_surrounding_cells(pos)
	for dir in temp_array:
		if grid.cells[str(dir)]["is_path"] == true:
			pushable_direction.append(dir)

func _on_body_entered(body: Node) -> void:
	if body is MainCharacter:
		var _direction : Vector2 = body.character_controller.direction
		if pushable_direction.find(_direction) != -1:
			var index =  pushable_direction.find(_direction)
			var next_pos =  pushable_direction.get(index)
			characterController.move_to(position, next_pos)
