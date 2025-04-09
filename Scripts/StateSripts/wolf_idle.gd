extends IdleAnimal

class_name IdleWolf

func enter_state():
	print("From Wolf: Entered Idle")
	find_path_flag = false

func exit_state():
	print("From Wolf: Exited Idle")

func update_state():
	if Input.is_action_just_pressed("mouse_left"):
		if !character.health:
			print("From Wolf: There not health inside wolf")
			return
		character.health.damage(15)
		print("From Wolf: current health is: ", character.health.current_health)
	# Skip turn when caughted by trap
	if character.is_stun:
		character.turnbase_actor.emit_endturn()
		return
	# Not in turn, cannot do anything
	# Or just found the paths
	if !character.turnbase_actor.is_active or find_path_flag:
		return
	
	finding_path()
	
	# Kiểm tra xem animal có đang trong vùng của Sói không
	if check_to_switch_to_bite(): return
	# Không tìm được paths thì chuyển sang tụ lượt
	if check_to_switch_to_charge(): return
	# Ngược lại, khi tìm được path thì ngay lập tức di chuyển
	if paths.is_empty():
		character.turnbase_actor.emit_endturn()
		return
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

func check_to_switch_to_bite() -> bool:
	var level_manager : LevelManager = character.get_tree().get_first_node_in_group("LevelManager")
	var wolf_zone : Array[Vector2i] = []
	# Init the zone, it must be recreate every single turn
	wolf_zone = get_surrounding_zone()
	
	# Check if animal is in the zone
	for animal in level_manager.animals_manager.animals:
		var animal_local_pos : Vector2i = character.grid.local_to_map(animal.position)
		if wolf_zone.has(animal_local_pos):
			SwitchState.emit(self, "bitting")
			return true
	
	return false

func check_to_switch_to_charge() -> bool:
	var _character_local_pos : Vector2i = character.grid.local_to_map(character.position)
	var charge_rate : float = character.charge_rate
	var random : float = randf_range(0.0, 100.0)
	
	# Kiểm tra các trường hợp mà Sói thay đổi tỉ lệ
	# 1. Là gate keeper:
	# 2. Đang đứng gần bụi cỏ hoặc ở trong bụi cỏ
	# 3. Đang đứng gần ngã rẽ
	if character.role == Wolf.Role.GATE_KEEPER or check_near_grass() or check_near_cross():
		print("From Wolf Idle: Change charge rate to 65%")
		charge_rate = 75.0 # Tỉ lệ là 65%
	
	# Nếu như không tìm thấy đường đi thì 100% charging
	if random in range(0.0, charge_rate) or paths.is_empty():
		SwitchState.emit(self, "charging")
		return true
	print("From Wolf Idle: Cannot switch to Charging")
	return false


func check_near_grass() -> bool:
	var tallgrass_manager : TallGrassManager = get_tree().get_first_node_in_group("TallGrassManager")
	var wolf_zone : Array[Vector2i] = get_surrounding_zone()
	for grass in tallgrass_manager.tall_grasses:
		if wolf_zone.has(grass.local_position):
			print("From Wolf Idle: There is a grass near wolf")
			return true
	return false


func check_near_cross() -> bool:
	var wolf_zone : Array[Vector2i] = get_surrounding_zone()
	var obstacle_counter : int = 0
	var max_obstacle_counting : int = 3
	
	for zone in wolf_zone:
		if character.grid.is_path(zone):
			obstacle_counter += 1
			if obstacle_counter >= max_obstacle_counting:
				return true
	
	return false
