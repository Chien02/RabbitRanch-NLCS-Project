extends Node2D

class_name ObstacleManagement

var obstacles = []
var grid : Grid

func set_grid(_grid: Grid):
	grid = _grid

func spawn_obstacle():
	if grid.cells.is_empty(): return
	for cell in grid.cells:
		if grid.cells[str(cell)]["is_path"] == false:
			var new_obs = preload("res://Scenes/Entity/obstacle.tscn").instantiate()
			new_obs.global_spawn = grid.map_to_local(string_to_vector2(cell))
			add_child.call_deferred(new_obs)
	
	init_obstacle()


func init_obstacle():
	obstacles = get_children()
	if obstacles.is_empty(): return
	
	for obstacle in obstacles:
		if obstacle is Obstacle:
			obstacle.grid = grid
			obstacle.init_pushable_diretion()

func string_to_vector2(string := "") -> Vector2:
	if string:
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2(int(array[0]), int(array[1]))

	return Vector2.ZERO
