extends TileMapLayer

class_name Grid

enum {
	WATER,
	PATH,
	OBSTACLE,
	PLAYER_PATH,
	TARGET_PATH,
	DESTINATION,
	MOUSE_LAYER,
	PLAYER_ZONE
}

@export var max_x_size : int = 20
@export var max_y_size : int = 12
@export var destination_source_id : int = 5
@export var tile_size : int = 16
@export var obstacles_management : ObstacleManagement
@export var item_manager : ItemManager
var characters = [] # Array[MainCharacter]

# Dictionaries
var cells = {}
var update_cells : Array[Vector2i]= []
var foods_on_field = {}

var destination : Vector2i = Vector2i.ZERO
var barrel_id : int = 6
var fench_id : int = 6
var obstacle_source_id : Array[int] = [barrel_id, fench_id]

# Đây là danh sách dùng để kiểm tra các tile không đi được
var isnot_path : Array[Vector2i] = [
	Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2),
	Vector2i(0, 3), Vector2i(1, 3), Vector2i(2, 3),
	Vector2i(4, 3), Vector2i(5, 3), Vector2i(6, 3), Vector2i(7, 3)
]


func _ready() -> void:
	characters = get_tree().get_nodes_in_group("MainCharacter")
	init_grid()
	scan_destination()
	if !item_manager: return
	item_manager.get_items()

func _process(_delta: float) -> void:
	display_mouse_hover()

func rescan(player_zone: Array[Vector2i] = []):
	init_grid()
	obstacles_management.scan_obstacle()
	scan_player_zone(player_zone)
	if !item_manager: return
	item_manager.get_items()
	
	if update_cells.is_empty(): return
	for cell in update_cells:
		cells[str(cell)]["is_path"] = true

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
			
	for str_cell in cells:
		var cell = string_to_vector2(str_cell)
		var path_layer : TileMapLayer = get_child(PATH)
		var path_source_id : int = 7
		if path_layer.get_cell_source_id(cell) == path_source_id:
			var atlas_cord = path_layer.get_cell_atlas_coords(cell)
			cells[str_cell]["is_path"] = !isnot_path.has(atlas_cord)
	

# This function use to tell player which tile the cursor points to
func display_mouse_hover():
	var mouse_layer_id = MOUSE_LAYER
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
		WATER: layer = $Water
		PATH: layer = $Path
		OBSTACLE: layer = $Obstacle
		PLAYER_PATH: layer = $Player_path
		TARGET_PATH: layer = $Target_path
		DESTINATION: layer = $Destination
		MOUSE_LAYER: layer = $Mouse_layer
		PLAYER_ZONE: layer = $PlayerZone
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
	if !door:
		destination = Vector2i.ZERO
	else:
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
		update_cells.append(_pos)
		
		cells[str(_pos)] = {
			"is_path": _is_path,
			"player_zone": player_zone
		}

func get_center_of_tile(tile_pos: Vector2i) -> Vector2:
	var center : Vector2 = Vector2.ZERO
	var center_pos : float = tile_size * sqrt(2)
	center = Vector2(tile_pos) + Vector2(center_pos, center_pos)
	return center
