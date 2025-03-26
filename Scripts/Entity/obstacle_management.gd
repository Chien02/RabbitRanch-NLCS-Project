extends Node2D

class_name ObstacleManagement

var obstacles = []
var grid : Grid

func set_grid(_grid: Grid):
	grid = _grid

func get_obstacles_dictionary():
	var temp_obs = {}
	for obstacle in obstacles:
		if obstacle is Obstacle:
			var local_pos = obstacle.local_position
			temp_obs[str(local_pos)] = {
				"pushable": obstacle.pushable,
				"breakable": obstacle.breakable
			}
		
			grid.cells[str(local_pos)] = {
				"is_path" = false,
				"player_zone" = false
			}
	return temp_obs

func spawn_obstacle():
	if grid.obstacles.is_empty(): return
	 # Obstacle instance
	for obs in grid.obstacles:
		var local_obs = grid.string_to_vector2(obs)
		if grid.obstacles[str(obs)]["pushable"]:
			var new_obs = preload("res://Scenes/Entity/barrel.tscn").instantiate()
			new_obs.global_spawn = grid.map_to_local(local_obs)
			add_child.call_deferred(new_obs)
		elif !grid.obstacles[str(obs)]["pushable"]:
			var new_obs = preload("res://Scenes/Entity/fench.tscn").instantiate()
			new_obs.global_spawn = grid.map_to_local(local_obs)
			add_child.call_deferred(new_obs)
	call_deferred("init_obstacle")

func init_obstacle():
	obstacles.clear()
	obstacles = get_children()
	if obstacles.is_empty():
		print("O.Management: Obstacles is empty")
		return
	for obstacle in obstacles:
		if obstacle is Obstacle:
			obstacle.grid = grid
			obstacle.init_pushable_diretion()
