extends CharacterBody2D

class_name CharacterController

@export var tile_size : int = 16
var speed : float = 10.0
var is_walking : bool = false
var can_walk : bool = true
var direction : Vector2

func movement(_object, _delta: float):
	if is_walking: return
	if !_object.grid: return
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").floor()
	
	if direction == Vector2.ZERO or direction.x != 0 and direction.y != 0: return
	
	var next_position : Vector2 = _object.position.floor() + direction * tile_size
	# Check if next_position is a obstacle or the bound then player can move to that next_position
	var local_next_pos : Vector2i = _object.grid.local_to_map(next_position)
	if _object.grid:
		can_walk = false if !_object.grid.is_within_grid(next_position) or not _object.grid.cells[str(local_next_pos)]["is_path"]  else true
	if !can_walk:
		is_walking = false
		return
	else:
		is_walking = true
	CustomTween.movement(_object, next_position, speed * _delta)
	await _object.get_tree().create_timer(speed * _delta).timeout
	is_walking = false
	
func move_to(_current_pos: Vector2, _direction: Vector2):
	_current_pos += _direction * tile_size
