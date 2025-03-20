extends Node2D

class_name ObstacleManagement

var obstacles = []
var grid : Grid

func set_grid(_grid: Grid):
	grid = _grid

func get_obstacles():
	var temp_obs : Array[Vector2i] = []
	for obstacle in obstacles:
		var local_pos = grid.local_to_map(obstacle.position)
		temp_obs.append(local_pos)
	return temp_obs

func spawn_obstacle():
	if grid.cells.is_empty(): return
	for cell in grid.cells:
		var local_cell = grid.string_to_vector2(cell)
		if not grid.is_path(local_cell):
			var new_obs = preload("res://Scenes/Entity/obstacle.tscn").instantiate()
			new_obs.global_spawn = grid.map_to_local(local_cell)
			add_child.call_deferred(new_obs)
	call_deferred("init_obstacle")


func init_obstacle():
	obstacles = get_children()
	if obstacles.is_empty():
		print("O.Management: Obstacles is empty")
		return
	for obstacle in obstacles:
		if obstacle is Obstacle:
			obstacle.grid = grid
			obstacle.init_pushable_diretion()
