extends Node2D

class_name LogsManager

enum State {
	HEAD, BODY, TAIL
}

enum Direction {
	LEFT, RIGHT, UP, DOWN
}

@export_enum("LEFT", "RIGHT", "UP", "DOWN") var falling_direction : int
@export var num_of_tile : int = 1

@onready var grid : Grid = get_tree().get_first_node_in_group("Grid")


func spawn_log():
	var tile_size : int = 16
	var objects_manager = get_tree().get_first_node_in_group("Object")
	
	for index in range(0, num_of_tile):
		var _log = load("res://Scenes/Entity/log.tscn").instantiate()
		# Set log sprite
		if index == 0:
			_log.get_node("Sprite2D").frame = State.HEAD
		elif index == num_of_tile - 1:
			_log.get_node("Sprite2D").frame = State.TAIL
		else:
			_log.get_node("Sprite2D").frame = State.BODY
		
		# Set _log position
		_log.global_position = global_position
		match falling_direction:
			Direction.LEFT: _log.global_position += Vector2(-tile_size * (index + 1), 0)
			Direction.RIGHT: _log.global_position += Vector2(tile_size * (index + 1), 0)
			Direction.UP: _log.global_position += Vector2(0, -tile_size * (index + 1))
			Direction.DOWN: _log.global_position += Vector2(0, tile_size * (index + 1))
		
		# Change properties at that spot
		var local_pos : Vector2i = grid.local_to_map(_log.global_position)
		grid.change_tile_property(local_pos, true, false)
		
		# Add log to the scene
		
		objects_manager.call_deferred("add_child", _log)
