extends Node2D

class_name TallGrassManager

var tall_grasses : Array[TallGrass] = []
var animals_inside : Array[Animal] = []
var player_inside : Array[MainCharacter] = []

func _ready() -> void:
	for grass in get_tree().get_nodes_in_group("TallGrass"):
		tall_grasses.append(grass)
		grass.AnimalEntered.connect(hide_animal)
		grass.AnimalExited.connect(stop_hide_animal)
		grass.PlayerEntered.connect(hide_player)
		grass.PlayerExited.connect(stop_hide_player)
		grass.root = grass
	init_bushed()

func init_bushed():
	tall_grasses[0].visited = true
	for child in tall_grasses:
		for grass in tall_grasses:
			var temp_neighbors : Array[Vector2i] = grass.grid.get_surrounding_cells(child.local_position)
			if temp_neighbors.has(grass.local_position) and !grass.visited:
				grass.root = child
				grass.visited = true
	
	for child in tall_grasses:
		print("From TallGrassM: grass: ", child.name," root = ", child.root.name, " and visited: ", child.visited)

func get_root(grass: TallGrass):
	while grass != grass.root:
		grass = grass.root
	return grass

func hide_animal(body: Character, local_pos: Vector2i):
	print("From TallGrassManager: Hide animal: ", body.name)
	if body is not Animal: return
	if animals_inside.has(body): return
	animals_inside.append(body)
	body.set_visible(false)
	check_animal_inside(true, local_pos)

func stop_hide_animal(body: Character):
	for grass in tall_grasses:
		if grass.grid.local_to_map(body.position) == grass.local_position:
			print("From TallGrassManager: animal: ", body.name, " still inside")
			return
	print("From TallGrassManager: Stop hide animal: ", body.name)
	if body is not Animal: return
	animals_inside.erase(body)
	body.set_visible(true)
	body.set_modulate(Color(1, 1, 1, 1))

func hide_player(body: Character, local_pos: Vector2i):
	if !player_inside.has(body):
		player_inside.append(body)
	body.modulate = Color(1, 1, 1, 0.65)
	if animals_inside.is_empty():
		print("From TallGrassManager: There is no animals inside, so cannot visible them")
		return
	check_animal_inside(false, local_pos)

func stop_hide_player(body: Character):
	for grass in tall_grasses:
		if grass.grid.local_to_map(body.position) == grass.local_position:
			print("From TallGrassManager: Player still inside tall grass")
			return
	
	print("From TallGrassManager: Stop hide player")
	body.set_modulate(Color(1, 1, 1, 1))
	if animals_inside.is_empty(): return
	for animal in animals_inside:
		if animal == null: continue
		animal.set_visible(false)

func check_animal_inside(is_animal: bool, pos : Vector2i = Vector2i.ZERO):
	for player in player_inside:
		for animal in animals_inside:
			if animal == null: continue
			var animal_pos : Vector2i
			var player_pos : Vector2i
			if is_animal and pos != Vector2i.ZERO:
				animal_pos = pos
				player_pos = player.grid.local_to_map(player.position)
			elif !is_animal and pos != Vector2i.ZERO:
				player_pos = pos
				animal_pos = animal.grid.local_to_map(animal.position)
			else:
				animal_pos = player.grid.local_to_map(animal.position)
				player_pos = player.grid.local_to_map(player.position)
			
			var animal_grass = get_grass_at(animal_pos)
			var player_grass = get_grass_at(player_pos)
			if !animal_grass or !player_grass:
				print("From TGM: Cannot get grass at player:",player_pos, " or animal:", animal_pos)
				continue
			var animal_root = get_root(animal_grass)
			var player_root = get_root(player_grass)
			if animal_root != player_root:
				print("From TGM: Can't get animal root: ", animal_root.local_position, " player root: ", player_root.local_position)
				continue
			print("From TGM: animal at pos:", animal_pos," root: ", animal_root.name, " player at pos: ", player_pos,"root: ", player_root.name)
			animal.set_visible(true)
			animal.set_modulate(Color(1, 1, 1, 0.65))

func get_grass_at(local_pos: Vector2i):
	for grass in tall_grasses:
		if grass.grid.local_to_map(grass.global_position) == local_pos:
			return grass
	return null
