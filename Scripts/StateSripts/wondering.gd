extends BaseState

class_name Wondering

var random_choice = -1

func enter_state(_value: Node2D = null):
	print(character.name, " enter wondering state")
	reset()

func exit_state():
	print(character.name, " exit wondering state")

func update_state():
	if random_choice != -1:
		print("Wondering state: Loop error, random_choice = ", random_choice, " ")
		return
	switch_to()

func reset():
	random_choice = -1

func switch_to():
	random_choice = randi_range(0, 10)
	print("From Wonder State: Random choice is: ", random_choice)
	match random_choice:
		0, 1, 2, 3, 4, 5, 6, 7, 8, 9: switch_to_walk()
		10: switch_to_idle()

func switch_to_idle():
	SwitchState.emit(self, "idle")
	if character is Animal:
		character.turnbase_actor.emit_endturn("I finished Wondering")

func switch_to_walk():
	var duration = 0.35
	var grid : Grid = get_tree().get_first_node_in_group("Grid")
	# Tạo khu vực xung quanh và chọn đường đi khả dụng trong đó
	var neighbors : Array[Vector2i] = grid.get_surrounding_cells(grid.local_to_map(character.global_position))
	var final_neighbors : Array[Vector2i]
	var chests = get_tree().get_nodes_in_group("Chest")
	var characters = get_tree().get_nodes_in_group("MainCharacter")
	var combine_array = chests + characters
		
	# Lọc các neighbor
	# 1.Không là vị trí trùng với character
	# 2.Không là chest
	# 3.Không là not is_path
		
	for neighbor in neighbors:
		if !grid.is_within_grid(neighbor):
			print("From Wonder State: disqualified: ", neighbor)
			continue
		print("From Wonder State: check tile: ", neighbor)
		for object in combine_array:
			var local_pos : Vector2i = grid.local_to_map(object.position)
			print("From Wonder State: compare tile: ", neighbor, " with local_pos: ", local_pos)
			if neighbor != local_pos and grid.is_path(neighbor) and !final_neighbors.has(neighbor):
				print("From Wonder State: Adding tile: ", neighbor)
				final_neighbors.append(neighbor)
		
	if final_neighbors.is_empty():
		print("From Wonder State: There is no walkable tile")
		# Trường hợp sau vòng lặp mà không tìm được đường đi thì kết thúc lượt luôn
		character.turnbase_actor.emit_endturn("I stopped find wondering path")
		SwitchState.emit(self, "idle")
	else:
		print("From Wonder State: final_neighbors: ", final_neighbors)
		var next_pos = grid.map_to_local(final_neighbors.pick_random())
		print("From Wonder State: Chose next_pos is: ", next_pos)
		character.character_controller.move_to(character, next_pos, duration)
		if character.character_controller.is_walking:
			SwitchState.emit(self, "walking")
