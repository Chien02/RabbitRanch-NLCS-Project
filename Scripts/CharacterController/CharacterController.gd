extends CharacterBody2D

class_name CharacterController

@export var tile_size : int = 16
var speed : float = 10.0
var is_walking : bool = false
var can_walk : bool = true
var is_face_same_dir : bool = false
var direction : Vector2

func movement(_object, _delta: float):
	if is_walking: return
	if !_object.grid: return
	if !is_just_type_input(): return
	
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").floor()
	
	if direction == Vector2.ZERO or direction.x != 0 and direction.y != 0:
		return
	
	var next_position : Vector2 = _object.position + direction * tile_size
	var local_next_pos : Vector2i = _object.grid.local_to_map(next_position)
	# Check if next_position is a obstacle or the bound then player can move to that next_position
	if _object.grid:
		# Check input is the same to current direction that character is facing
		if check_direction(_object, direction):
			can_walk = _object.grid.is_within_grid(local_next_pos) and _object.grid.is_path(local_next_pos)
		else:
			can_walk = false
		print("From CharacterController: Checking can_walk: ", can_walk,"and next_local_pos: ", local_next_pos, " is_path: ", _object.grid.is_path(local_next_pos))
	is_walking = true if can_walk else false
	if !is_walking: return
	
	CustomTween.movement(_object, next_position, speed * _delta)
	await _object.get_tree().create_timer(speed * _delta).timeout
	is_walking = false

func is_just_type_input():
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down") or Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		return true
	return false

func check_direction(character, dir: Vector2):
	if character.facing_direction != dir:
		character.facing_direction = dir
		return false
	return true

func move_to(_object, next_pos: Vector2, duration: float):
	is_walking = true
	CustomTween.movement(_object, next_pos, duration)
	await _object.get_tree().create_timer(duration).timeout
	is_walking = false
