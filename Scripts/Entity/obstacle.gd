extends RigidBody2D

class_name Obstacle

var grid : Grid
var pushable_direction : Array[Vector2i] = []
var character_controller : CharacterController
var global_spawn
var local_position

func _ready() -> void:
	character_controller = CharacterController.new()
	global_position = global_spawn

func reset():
	pushable_direction.clear()
	if grid:
		local_position = grid.local_to_map(global_position)

func init_pushable_diretion():
	reset()
	var pos = grid.local_to_map(position)
	var temp_array = grid.get_surrounding_cells(pos)
	for dir in temp_array:
		if grid.is_within_grid(dir) and grid.is_path(dir):
			pushable_direction.append(dir)

func is_in_pushable_dir(dir: Vector2i):
	return pushable_direction.has(dir)

func _on_body_entered(body: Node) -> void:
	pass
	#if body is MainCharacter:
		#var _direction : Vector2 = body.character_controller.direction
		#if pushable_direction.find(_direction) != -1:
			#var index =  pushable_direction.find(_direction)
			#var next_pos =  pushable_direction.get(index)
			#characterController.move_to(position, next_pos)
