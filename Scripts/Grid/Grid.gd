extends TileMapLayer

class_name Grid

@export var max_x_size : int = 20
@export var max_y_size : int = 12
@export var destination_source_id : int = 5
@export var tile_size : int = 16
@export var obstacles_management : ObstacleManagement
@export var item_manager : ItemManager
var characters = [] # Array[MainCharacter]

# Dictionaries
var cells = {}
var foods_on_field = {}

var destination : Vector2i = Vector2i.ZERO
var barrel_id : int = 6
var fench_id : int = 6
var obstacle_source_id : Array[int] = [barrel_id, fench_id]

func _ready() -> void:
	characters = get_tree().get_nodes_in_group("MainCharacter")
	init_grid()
	scan_destination()
	item_manager.get_items()

func _process(_delta: float) -> void:
	display_mouse_hover()

func rescan(player_zone: Array[Vector2i] = []):
	init_grid()
	obstacles_management.scan_obstacle()
	scan_player_zone(player_zone)
	item_manager.get_items()
	#print("From Grid: Grid rescaned")

func init_grid():
	# Check for the water
	var water_layer : TileMapLayer = $Water
	var water_source_id : int = 0
	var filling_water : Vector2i = Vector2i(10, 0)
	var is_water : bool = false
		
	# Init for the path
	for x in range(0, max_x_size):
		for y in range(0, max_y_size):
			is_water = water_layer.get_cell_source_id(Vector2i(x, y)) == water_source_id and water_layer.get_cell_atlas_coords(Vector2i(x, y)) != filling_water
			
			cells[str(Vector2i(x, y))] = {
				"is_path" = !is_water,
				"player_zone" = false
			}
	

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
		6: layer = $PlayerZone
	for x in range(0, max_x_size):
		for y in range(0, max_y_size):
			layer.erase_cell(Vector2i(x, y))

func scan_player_zone(player_zone: Array[Vector2i] = []):
	# When there is not have agruments, scan for all player
	if player_zone.is_empty():
		for player in characters:
			for zone in player.player_zone:
				if is_within_grid(zone):
					cells[str(zone)]["player_zone"] = true
		return
	# Else just update for the one agruments
	for zone in player_zone:
		if is_within_grid(zone):
			cells[str(zone)]["player_zone"] = true

func scan_destination():
	var door : Destination = get_tree().get_first_node_in_group("Destination")
	destination = local_to_map(door.position)

#The _position is still in the local coordinate, so in this function, it will turn to map coordinate
#then compare to obstacles dictionary to find out: Is it an obstacle?

# This function use to check that character is in the map or not
func is_within_grid(_position: Vector2i) -> bool:
	var local_coord = _position
	var inside_x = local_coord.x < max_x_size-1 and local_coord.x >= 0
	var inside_y = local_coord.y < max_y_size-1 and local_coord.y >= 0
	return inside_x and inside_y


func is_path(local_pos: Vector2i):
	return not obstacles_management.is_obstcle_pos(local_pos) and cells[str(local_pos)]["is_path"]


func is_player_zone(local_pos: Vector2i):
	return cells[str(local_pos)]["player_zone"]

func string_to_vector2(string := "") -> Vector2i:
	if string:
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2i(int(array[0]), int(array[1]))

	return Vector2i.ZERO

func change_tile_property(_pos: Vector2i, _is_path: bool = true, player_zone: bool = false):
	if cells.has(str(_pos)):
		cells[str(_pos)] = {
			"is_path": _is_path,
			"player_zone": player_zone
		}
