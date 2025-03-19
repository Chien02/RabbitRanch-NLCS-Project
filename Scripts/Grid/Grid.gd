extends TileMapLayer

class_name Grid

@export var max_x_size : int = 20
@export var max_y_size : int = 12
@export var obstale_source_id : int = 1
@export var destination_source_id : int = 5
@export var tile_size : int = 16
@export var obstacles_management : ObstacleManagement

var cells = {}
var destination : Vector2i = Vector2i.ZERO

func _ready() -> void:
	init_grid()
	scan_obstacles($Obstacle)
	scan_destination()
	obstacles_management.set_grid(self)
	obstacles_management.spawn_obstacle()

func _process(_delta: float) -> void:
	display_mouse_hover()

# As its name
func init_grid():
	# Init for the path
	for x in range(0, max_x_size):
		for y in range(0, max_y_size):
			cells[str(Vector2i(x, y))] = {
				"is_path" = true
			}
			$Path.set_cell(Vector2i(x, y), 6, Vector2i(2, 6))

# This function use to tell player which tile the cursor points to
func display_mouse_hover():
	var mouse_layer_id = 5
	var mouse_pos = get_global_mouse_position()
	var mouse_coordination = local_to_map(mouse_pos)
	if cells.has(str(mouse_coordination)):
		clear_layer(mouse_layer_id)
		hover(mouse_coordination)
	else:
		clear_layer(mouse_layer_id)
	
func hover(_position: Vector2i):
	$Mouse_layer.set_cell(_position, 4, Vector2i(0, 0))
	
func unhover(_position: Vector2i):
	$Mouse_layer.set_cell(_position, -1)

# This function is using for clear all tile in the layer
func clear_layer(layer_id: int):
	var layer : TileMapLayer
	match layer_id:
		0: layer = $Path
		1: layer = $Obstacle
		2: layer = $Player_path
		3: layer = $Target_path
		4: layer = $Destination
		5: layer = $Mouse_layer
	
	for x in range(0, max_x_size):
		for y in range(0, max_y_size):
			layer.erase_cell(Vector2i(x, y))

#Load in Obstacle Layer to find obstacles and add them to the Obstacles dictionary
func scan_obstacles(layer: Node):
	for x in range(0, max_x_size):
		for y in range(0, max_y_size):
			if layer.get_cell_source_id(Vector2i(x, y)) == obstale_source_id:
				cells[str(Vector2i(x, y))] = {
					"is_path" = false
				}

func scan_destination():
	var door : Destination = get_tree().get_first_node_in_group("Destination")
	destination = local_to_map(door.position)

#The _position is still in the local coordinate, so in this function, it will turn to map coordinate
#then compare to obstacles dictionary to find out: Is it an obstacle?

# This function use to check that character is in the map or not
func is_within_grid(_position: Vector2) -> bool:
	var local_coord = local_to_map(_position)
	var inside_x = local_coord.x < max_x_size and local_coord.x >= 0
	var inside_y = local_coord.y < max_y_size and local_coord.y >= 0
	return inside_x and inside_y
