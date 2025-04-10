extends IdleAnimal

class_name IdleWolf

var find_prey_flag : bool = false

func enter_state(_value: Node2D = null):
	print("From Wolf Idle: Entered Idle")
	find_path_flag = false
	find_prey_flag = false
	# Kết nối với area của người chơi
	if !character.area.body_entered.is_connected(_on_character_body_enter):
		character.area.body_entered.connect(_on_character_body_enter)
	
	if character.turnbase_actor:
		character.area.get_child(0).disabled = !character.turnbase_actor.is_active


func exit_state():
	print("From Wolf Idle: Exited Idle")

func update_state():
	if character.area.get_child(0).disabled == true:
		character.area.get_child(0).disabled = false
	# Kết thúc lượt luôn nếu bị trap
	if character.is_stun:
		print("From Wolf Idle: Being stunned, skip this turn")
		find_path_flag = false
		find_prey_flag = false
		character.area.get_child(0).disabled = true # tắt collider tránh gây lỗi
		character.turnbase_actor.emit_endturn("I'm being stunned")
		return
	
	if !character.turnbase_actor.is_active or find_path_flag:
		print("From Wolf Idle: not your turn or find_path_flag is off")
		return
	
	finding_path()
	
	# Không tìm được paths thì chuyển sang tụ lượt
	if check_to_switch_to_charge(): return
	# Ngược lại, khi tìm được path thì ngay lập tức di chuyển
	if find_prey_flag: return
	await get_tree().create_timer(0.25).timeout
	find_prey_flag = true
	print("From Wolf Idle: Waited for 0.5 to received signal")
	switch_to_walk()

func finding_path():
	paths.clear()
	var nearest_animal : Animal = get_nearest_animal()
	if nearest_animal == null:
		print("From Wolf Idle: Could not get the nearest animal")
		return
	
	var nearest_animal_pos : Vector2i = character.grid.local_to_map(nearest_animal.position)
	var is_wolf : bool = true
	paths = character.astar.get_the_path(character.option, character.mode, nearest_animal_pos, is_wolf)
	find_path_flag = true

func switch_to_walk():
	# Trường hợp đã có con vật ở trong vùng:
	if character.target:
		print("From Wolf Idle: Already had target, switch to bitting")
		find_prey_flag = false
		find_path_flag = false
		character.area.get_child(0).disabled = true
		SwitchState.emit(self, "bitting", character.target)
		return
	
	if character.charge_point == 0 and !character.character_controller.is_walking:
		print("From Wolf Idle: Out of charge point, stop walking")
		character.charge_point = 1
		# Reset all the variables
		find_path_flag = false
		find_prey_flag = false
		character.area.get_child(0).disabled = true
		character.turnbase_actor.emit_endturn("I'm run out of charge point")
		return
	
	print("From Wolf Idle: charge point before walk: ", character.charge_point)
	character.charge_point -= 1
	var duration = 0.5
	var next_pos = character.grid.map_to_local(paths[max(paths.size() - 2, 0)].position)
	character.character_controller.move_to(character, next_pos, duration)
	if character.character_controller.is_walking:
		print("From Wolf Idle: switch to walking")
		character.area.get_child(0).disabled = true
		SwitchState.emit(self, "walking")
		return

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
	
	print("From Wolf Idle: find the prey, it's name is: ", nearest_animal.name)
	return nearest_animal

func check_to_switch_to_charge() -> bool:
	var _character_local_pos : Vector2i = character.grid.local_to_map(character.position)
	var charge_rate : float = character.charge_rate
	var random : float = randf_range(0.0, 100.0)
	
	# Kiểm tra các trường hợp mà Sói thay đổi tỉ lệ
	# 1. Là gate keeper:
	# 2. Đang đứng gần bụi cỏ hoặc ở trong bụi cỏ
	# 3. Đang đứng gần ngã rẽ
	if character.role == Wolf.Role.GATE_KEEPER or check_near_grass() or check_near_cross():
		print("From Wolf Idle: Change charge rate to 75%")
		charge_rate = 75.0 # Tỉ lệ là 65%
	
	# Nếu như không tìm thấy đường đi thì 100% charging
	if random in range(0.0, charge_rate) or paths.is_empty():
		print("From Wolf Idle: Switch to Charging")
		character.area.get_child(0).disabled = true
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

func _on_character_body_enter(body: Node2D):
	if !character.turnbase_actor.is_active: return
	if body is Wolf: return
	print("From Wolf Idle: ", body.name, " entered zone <---------")
	character.target = body
