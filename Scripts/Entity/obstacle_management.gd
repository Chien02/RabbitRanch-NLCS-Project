extends Node2D

class_name ObstacleManagement

@export var grid : Grid
var obstacles : Array[Obstacle] = []

func _ready():
	if !grid: return
	call_deferred("init_obstacles")
	call_deferred("scan_obstacle")

func init_obstacles():
	var obstacle_layer : TileMapLayer = grid.get_node("Obstacle")
	var ground_layer_index : int = 6
	var fench_atlas_coord : Vector2i = Vector2i(8, 6)
	var barrel_atlas_coord : Vector2i = Vector2i(7, 5)
	
	for x in range(0, grid.max_x_size):
		for y in range(0, grid.max_y_size):
			var new_obstacle : Obstacle = null
			if obstacle_layer.get_cell_source_id(Vector2i(x, y)) != ground_layer_index: continue
			if obstacle_layer.get_cell_atlas_coords(Vector2i(x, y)) == fench_atlas_coord:
				new_obstacle = preload("res://Scenes/Entity/fench.tscn").instantiate()
			elif obstacle_layer.get_cell_atlas_coords(Vector2i(x, y)) == barrel_atlas_coord:
				new_obstacle = preload("res://Scenes/Entity/barrel.tscn").instantiate()
			if new_obstacle != null:
				new_obstacle.global_spawn = grid.map_to_local(Vector2i(x, y))
				new_obstacle.global_position = new_obstacle.global_spawn
				new_obstacle.init_pushable_diretion(grid)
				obstacles.append(new_obstacle)
				new_obstacle.Destroyed.connect(_on_osbtacle_destroyed)
				call_deferred("add_child", new_obstacle)

func scan_obstacle():
	if obstacles.is_empty():
		for child in get_children():
			if child is Obstacle:
				obstacles.append(child)
	
	for obstacle in obstacles:
		if obstacle == null:
			continue
		#print("From O.M: init obstacle at", grid.local_to_map(obstacle.position))
		obstacle.init_pushable_diretion(grid)
	print("From O.M: Obstacles's size:", obstacles.size())

func _on_osbtacle_destroyed(_local_pos: Vector2i):
	print("From O.M: Connected with Destroyed signal")
	scan_obstacle()

func is_obstcle_pos(local_pos: Vector2i):
	for obs in obstacles:
		if obs != null and obs.local_position == local_pos:
			return true
	return false

func get_obstacle_at(local_pos: Vector2i):
	for obs in obstacles:
		if obs != null and obs.local_position == local_pos:
			return obs
	return null
