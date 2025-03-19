extends Node2D

class_name Astar

var character
var grid : Grid
var open : Array[TilePath] = []
var close : Array[TilePath] = []

func _ready() -> void:
	if get_parent().is_in_group("Entity"):
		character = get_parent()
		if character is Animal:
			grid = character.grid

func reset():
	open.clear()
	close.clear()

func get_the_path(option: String = "ignore", mode: String = "not_diagonal"):
	find_path(option, mode)
	return close

func find_path(option: String = "ignore", mode: String = "not_diagonal"):
	match(option):
		"ignore": astar_ignore(mode)
		"not_ignore": astar(mode)

func astar_ignore(mode: String):
	if not character: return
	if not grid: return
	
	reset() # init all the things
	var init_tile = TilePath.new()
	init_tile.set_value(grid.local_to_map(character.position))
	
	open.append(init_tile)
	
	while (not open.is_empty()):
		var min_f_index = get_min_f(open)
		var current_tile : TilePath = open.pop_at(min_f_index)
		var neighbors = get_surrounding_tile(current_tile)
		for neighbor in neighbors:
			if check_tile_in_open(neighbor) == true:
				continue
			check_tile_in_close(neighbor)
		close.append(current_tile)


func astar(mode: String):
	pass


func check_tile_in_open(tile: TilePath):
	if open.is_empty(): return
	for child in open:
		if tile.position == child.position:
			if tile.f > child.f:
				return true
			else:
				return false

func check_tile_in_close(tile: TilePath):
	if close.is_empty(): return
	for index in range(0, close.size()):
		if tile.position == close[index].position:
			if tile.f < close[index].f:
				close.pop_at(index)
			open.append(tile)

func get_surrounding_tile(current_tile: TilePath) -> Array[TilePath]:
	var surrounding_position = grid.get_surrounding_cells(current_tile.position)
	var surrounding_tile : Array[TilePath]= []
	for index in range(0, surrounding_position.size()):
		var tile = TilePath.new()
		#surrounding_tile[index] = TilePath.new()
		tile.set_value(surrounding_position[index])
		tile.parent = current_tile
		
		# Defy that child tile is walkable or not
		if grid.cells.has(str(tile.position)):
			tile.is_path = grid.cells[str(tile.position)]["is_path"]
		
		# Compute the f value for each child
		calculate_cost(tile)
		calculate_heuristic(tile)
		tile.calculate_f()
		
		surrounding_tile.append(tile)
	
	return surrounding_tile


func calculate_heuristic(current_tile: TilePath, mode: String = "not_diagonal", option: String = "ignore"):
	if option == "ignore":
		if not current_tile.is_path: return
	
	if mode == "diagonal":
		# Using Diagonal Distance
		var dx = abs(current_tile.position.x - grid.destination.x)
		var dy = abs(current_tile.position.y - grid.destination.y)
		var d1 = grid.tile_size
		var d2 = grid.tile_size * sqrt(2.0)
		current_tile.heuristic = d1 * (dx + dy) + (d2 - 2 * d1) * min(dx, dy)
	else:
		# Using Mahattan Distance
		current_tile.heuristic = abs(current_tile.position.x + grid.destination.x) + abs(current_tile.position.y + grid.destination.y)


func calculate_cost(current_tile: TilePath, mode: String = "not_diagonal", option: String = "ignore"):
	if option == "not_ignore":
		if not current_tile.is_path: return
	
	if mode == "diagonal":
		current_tile.cost = current_tile.parent.cost + grid.tile_size * floorf(sqrt(2.0))
	else:
		current_tile.cost = current_tile.parent.cost + grid.tile_size

func get_min_f(array: Array[TilePath]):
	var temp_min : TilePath = array[0]
	var temp_min_index : int = 0
	
	for index in range(0, array.size()):
		if temp_min.f > array[index].f:
			temp_min = array[index]
			temp_min_index = index
	
	return temp_min_index
