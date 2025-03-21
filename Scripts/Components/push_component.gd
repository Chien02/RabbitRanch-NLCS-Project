extends Node2D

class_name PushComponent

var push_duration : float = 1.0
var can_push : bool = false
var is_pushing : bool = false
var temp_obstacle : Obstacle

var character : MainCharacter
var grid : Grid
var pushable_direction : Vector2 = Vector2.ZERO

func init_variable(_character: MainCharacter, _grid: Grid):
	character = _character
	grid = _grid

func pushing_check() -> void:
	if !character.character_controller.is_just_type_input(): return
	
	var direction = character.facing_direction
	if can_push and pushable_direction == direction:
		push(temp_obstacle, pushable_direction)
	
	
	var next_position : Vector2 = character.position.floor() + direction * grid.tile_size
	var local_next_pos : Vector2i = grid.local_to_map(next_position)
	
	if not grid.is_within_grid(local_next_pos): return
	if grid.is_path(local_next_pos): return
	
	var obstacles = grid.obstacles_management.obstacles
	for obs in obstacles:
		if local_next_pos != obs.local_position: continue
		
		var next_pos_push = local_next_pos + Vector2i(direction)
		if not grid.is_path(next_pos_push): return
		temp_obstacle = obs
		if pushable_direction != direction:
			pushable_direction = direction
		
		can_push = true if pushable_direction == direction else false

func push(_obs: Obstacle, dir: Vector2):
	if is_pushing: return
	turn_flag()
	_obs.character_controller.move_to(_obs, dir, push_duration)
	await character.get_tree().create_timer(push_duration).timeout
	turn_flag()
	can_push = false
	grid.rescan(character.player_zone)

func turn_flag():
	is_pushing = not is_pushing
