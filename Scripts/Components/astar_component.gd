extends Node2D

class_name Astar

var character
var grid : Grid
var paths : Array[TilePath] = []
var open : Array[TilePath] = []
var close : Array[TilePath] = []

func _ready() -> void:
	if get_parent().is_in_group("Entity"):
		character = get_parent()
		if character is Animal:
			grid = character.grid

func reset():
	paths.clear()
	open.clear()
	close.clear()

func get_the_path(option: String = "ignore", mode: String = "not_diagonal"):
	astar_ignore(option, mode)
	
	if close.is_empty(): return
	paths.append(close[close.size() - 1])
	
	var index : int = 1
	while (paths[index-1].parent != null):
		paths.append(paths[index-1].parent)
		index += 1
	
	#for path in paths:
		#print("path: ", path.position, " - is_path: ", path.is_path, " - is_player_zone: ", path.is_player_zone)
	return paths

func astar_ignore(_option: String, _mode: String):
	if not character: return
	if not grid: return
	
	reset() # init all the things
	var init_tile = TilePath.new()
	init_tile.set_value(grid.local_to_map(character.position))
	
	open.append(init_tile)
	while (not open.is_empty()):
		var min_f_index = get_min_f(open)
		var current_tile : TilePath = open.pop_at(min_f_index)
		#print("A* pop at: ", current_tile.position, " with f: ", current_tile.f) # debug
		var neighbors = get_surrounding_tile(current_tile, _option, _mode)
		for neighbor in neighbors:
			if neighbor.position == grid.destination:
				close.append(neighbor)
				#print("------------Found destination-------")
				return
			if check_in_open(neighbor) or check_in_close(neighbor):
				#print("Ignore: neighbor[", neighbor.position,"]")
				continue
			open.append(neighbor)
		
		close.append(current_tile)
		#print_list()

func check_in_open(tile: TilePath) -> bool:
	for node in open:
		if tile.position == node.position:
			if tile.f >= node.f:
				return true
	return false

func check_in_close(tile: TilePath) -> bool:
	for node in close:
		if tile.position == node.position:
			if tile.f >= node.f:
				return true
	return false

func get_surrounding_tile(current_tile: TilePath, _option: String = "ignore", _mode: String = "not_diagonal") -> Array[TilePath]:
	var surrounding_position
	var surrounding_tile : Array[TilePath]= []
	
	if _mode=="not_diagonal":
		surrounding_position = grid.get_surrounding_cells(current_tile.position)
	elif _mode == "diagonal":
		surrounding_position = grid.get_surrounding_cells(current_tile.position)
		
		# Adding four corner
		for x in range(current_tile.position.x - 1, current_tile.position.x + 2):
			for y in range(current_tile.position.y - 1, current_tile.position.y + 2):
				if x == y:
					surrounding_position.append(Vector2i(x, y))
				elif x == current_tile.position.x + 1 and y == current_tile.position.y - 1:
					surrounding_position.append(Vector2i(x, y))
				elif x == current_tile.position.x - 1 and y == current_tile.position.y + 1:
					surrounding_position.append(Vector2i(x, y))
	
	
	for index in range(0, surrounding_position.size()):
		var tile = TilePath.new()
		#surrounding_tile[index] = TilePath.new()
		tile.set_value(surrounding_position[index])
		tile.set_parent(current_tile)
		
		# Defy that child tile is walkable or not
		if grid.cells.has(str(tile.position)):
			tile.is_path = grid.is_path(tile.position)
			tile.is_player_zone = grid.is_player_zone(tile.position)
		
		# Compute the f value for each child
		calculate_cost(tile, _mode, _option)
		calculate_heuristic(tile, _mode, _option)
		tile.calculate_f()
		
		# Adding the tile that suitable for open
		if grid.is_within_grid(tile.position):
			# not_ignore
			if _option == "not_ignore":
				if !tile.is_player_zone:
					surrounding_tile.append(tile)
			# ignore
			elif _option == "ignore":
				if tile.is_path and !tile.is_player_zone:
					surrounding_tile.append(tile)
			
			#print("Surrounding tile: tile at ", tile.position, " with f: ", tile.f)
	
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
		current_tile.cost = current_tile.parent.cost + grid.tile_size * sqrt(2.0)
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

func print_list():
	print("-----Open-----")
	for pos in open:
		print(" - ", pos.position, " - f: ", pos.f)
	print("-----Close-----")
	for pos in close:
		print(" - ", pos.position, " - f: ", pos.f)
	print("--------------")
	
