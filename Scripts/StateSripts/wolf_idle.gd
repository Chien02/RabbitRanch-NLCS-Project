extends IdleAnimal

class_name IdleWolf

func enter_state():
	print("From Wolf: Entered Idle")
	find_path_flag = false

func exit_state():
	print("From Wolf: Exited Idle")

func update_state():
	print("From Wolf: inside update state")
	# Skip turn when caughted by trap
	if character.is_stun:
		character.turnbase_actor.emit_endturn()
		return
	# Not in turn, cannot do anything
	# Or just found the paths
	if !character.turnbase_actor.is_active or find_path_flag:
		return
	
	finding_path()
	
	# Không tìm được paths thì chuyển sang tụ lượt
	if paths.is_empty():
		print("From WolfIdle: Cannot find the paths to nearest animal")
		SwitchState.emit(self, "charging")
		return
	
	# Khi tìm được path thì ngay lập tức di chuyển
	switch_to_walk()

func finding_path():
	paths.clear()
	var nearest_animal : Animal = get_nearest_animal()
	if nearest_animal == null:
		print("From Wolf: Could not get the nearest animal")
		return
	
	var nearest_animal_pos : Vector2i = character.grid.local_to_map(nearest_animal.position)
	paths = character.astar.get_the_path(character.option, character.mode, nearest_animal_pos)
	find_path_flag = true

func get_nearest_animal() -> Animal:
	var animals = character.get_tree().get_nodes_in_group("Animal")
	var min_distance : float = 9999999.0
	var nearest_animal : Animal = null
	
	for animal in animals:
		if animal.is_in_group("Wolf"): continue
		var distance : float = sqrt(pow(animal.position.x - character.position.x, 2) + pow(animal.position.y - character.position.y, 2))
		if distance < min_distance:
			min_distance = distance
			nearest_animal = animal
			print("From Wolf: find the prey, it's name is: ", nearest_animal.name)
	return nearest_animal
