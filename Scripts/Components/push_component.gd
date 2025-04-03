extends Node2D

class_name PushComponent

var push_duration : float = 1.0
var can_push : bool = false
var is_pushing : bool = false
var temp_obstacle : Obstacle

var character : MainCharacter
var grid : Grid
var turnbase_manager: TurnBasedManager
var pushable_direction : Vector2 = Vector2.ZERO

func init_variable(_character: MainCharacter, _grid: Grid):
	character = _character
	grid = _grid
	turnbase_manager = character.get_tree().get_first_node_in_group("TurnBasedManager")

func pushing_check() -> void:
	if !character.character_controller.is_just_type_input(): return
	var direction = Input.get_vector("left", "right", "up", "down")
	var next_position : Vector2 = character.position.floor() + direction * grid.tile_size
	var local_next_pos : Vector2i = grid.local_to_map(next_position)
	
	if not grid.is_within_grid(local_next_pos): return
	if grid.is_path(local_next_pos): return
	
	var next_pos_push = local_next_pos + Vector2i(direction)
	var obstacle : Obstacle = grid.obstacles_management.get_obstacle_at(local_next_pos)
	if obstacle == null: return
	if is_overlap_actor(next_pos_push): return
		
	if pushable_direction != direction:
		pushable_direction = direction
	
	can_push = true if direction == character.facing_direction and pushable_direction == direction and obstacle.pushable else false
	if can_push:
		var global_next_pos = character.grid.map_to_local(next_pos_push)
		push(obstacle, global_next_pos)

func is_overlap_actor(pos: Vector2i):
	for actor in turnbase_manager.actor:
		var local_actor = grid.local_to_map(actor.position)
		if local_actor == pos:
			return true
	return false
	

func push(_obs: Obstacle, next_pos: Vector2):
	if is_pushing: return
	if _obs == null:
		print("From Push: Obstacle is disappeared")
		return
	turn_flag()
	_obs.character_controller.move_to(_obs, next_pos, push_duration)
	await character.get_tree().create_timer(push_duration).timeout
	turn_flag()
	can_push = false
	grid.rescan(character.player_zone)

func turn_flag():
	is_pushing = not is_pushing
