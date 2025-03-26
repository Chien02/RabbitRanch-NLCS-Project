extends RigidBody2D

class_name Obstacle

@export var breakable : bool = true
@export var pushable : bool = true

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
	var temp_array = grid.get_surrounding_cells(local_position)
	for dir in temp_array:
		if grid.is_within_grid(dir) and grid.is_path(dir):
			pushable_direction.append(dir)

func is_in_pushable_dir(dir: Vector2i):
	return pushable_direction.has(dir)

func is_breakable() -> bool:
	return breakable

func is_pushable() -> bool:
	return pushable

func destroy(duration: float):
	CustomTween.explode(self, duration)
	if !CustomTween.is_connected("finished", queue_free):
		CustomTween.connect("finished", queue_free)

func _on_body_entered(_body: Node) -> void:
	pass
