extends TileMapLayer

class_name Grid

@export var max_x_size : int = 20
@export var max_y_size : int = 20
@export var obstale_source_id : int = 1
@export var destination_source_id : int = 5

var cells = {}
var obstacles = {}
var destination : Vector2 = Vector2.ZERO

func _ready() -> void:
	init_grid()
	scan_obstacles($Obstacle)
	scan_destination($Destination)

func _process(_delta: float) -> void:
	display_mouse_hover()
	pass

func init_grid():
	for x in range(0, max_x_size):
		for y in range(0, max_y_size):
			cells[str(Vector2(x, y))] = {
				"is_path" = true
			}
			$Path.set_cell(Vector2(x, y), 0, Vector2i(0, 0))

func display_mouse_hover():
	var mouse_layer_id = 4
	var mouse_pos = get_global_mouse_position()
	var mouse_coordination = $Mouse_layer.local_to_map(mouse_pos)
	if cells.has(str(mouse_coordination)):
		clear_layer(mouse_layer_id)
		hover(mouse_coordination)
	else:
		clear_layer(mouse_layer_id)
	
func hover(_position: Vector2):
	$Mouse_layer.set_cell(_position, 4, Vector2i(0, 0))
	
func unhover(_position: Vector2):
	$Mouse_layer.set_cell(_position, -1)
	
func clear_layer(layer_id: int):
	var layer : TileMapLayer
	match layer_id:
		0: layer = $Path
		1: layer = $Obstacle
		2: layer = $Player_path
		3: layer = $Target_path
		4: layer = $Mouse_layer
	
	for x in range(0, max_x_size):
		for y in range(0, max_y_size):
			layer.erase_cell(Vector2i(x, y))

func scan_obstacles(layer: Node):
	for x in range(0, max_x_size):
		for y in range(0, max_y_size):
			if layer.get_cell_source_id(Vector2i(x, y)) == obstale_source_id:
				cells[str(Vector2(x, y))] = {
					"is_path" = false
				}
				obstacles[str(Vector2(x, y))] = {
					"coord" = Vector2(x, y)
				}

func scan_destination(layer: Node):
	for x in range(0, max_x_size):
		for y in range(0, max_y_size):
			if layer.get_cell_source_id(Vector2i(x, y)) == destination_source_id:
				destination = Vector2i(x, y)
				print("destination(", x, ", ", y,")")

#The _position is still in the local, so in this function, it will turn to map
#then compare to obstacles dictionary to find out: Is it an obstacle?
func is_obstacle(_position: Vector2) -> bool:
	if obstacles.is_empty():
		print("From Grid.gd: Obstacles is empty")
		return false
	
	_position = local_to_map(_position)
	
	print("Next position is: ", _position)
	for obstacle in obstacles:
		if obstacles.has(str(_position)):
			print("Encounter obstacle: ", _position)
			return true
	return false
