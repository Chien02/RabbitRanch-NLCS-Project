extends BaseState

class_name Wondering

var random_choice = -1

func enter_state(_value: Node2D = null):
	print(character.name, " enter wondering state")
	reset()

func exit_state():
	print(character.name, " exit wondering state")

func update_state():
	print("Wondering state: Loop error, random_choice = ", random_choice)
	if random_choice != -1: return
	switch_to()

func reset():
	random_choice = -1

func switch_to():
	random_choice = randi_range(0, 4)
	match random_choice:
		0, 1, 2, 3: switch_to_walk()
		4: switch_to_idle()

func switch_to_idle():
	SwitchState.emit(self, "idle")
	if character is Animal:
		character.turnbase_actor.emit_endturn("I finished Wondering")

func switch_to_walk():
	if character is Animal:
		var duration = 0.5
		var counter_loop = 0
		var max_counter_loop = 8
		# Tạo khu vực xung quanh và chọn đường đi khả dụng trong đó
		var neighbors : Array[Vector2i] = character.grid.get_surrounding_cells(character.local_position)
		var flag : bool = false
		while (flag == false and counter_loop < max_counter_loop):
			counter_loop += 1
			
			# Chọn ngẫu nhiên một vùng trong đó
			var index = randi_range(0, neighbors.size()-1)
			print("random number is : ", index)
			
			# Kiểm tra vùng đã chọn, nếu không có vùng nào thỏa việc chọn ngẫu nhiên sẽ được lặp lại
			if !character.grid.is_within_grid(neighbors[index]): continue
			if !character.grid.is_path(neighbors[index]): continue
			
			# Kiểm tra xem có trùng vị trí với người chơi hoặc sói không
			var overlap_flag: bool = false
			for _character in get_tree().get_nodes_in_group("Character"):
				if _character.local_position == neighbors[index]:
					overlap_flag = true
					break
			if overlap_flag: continue
			
			# Kiểm tra next pos
			var next_pos = character.grid.map_to_local(neighbors[index])
			print("Wondering state: go random to next_pos: ", next_pos)
			
			character.character_controller.move_to(character, next_pos, duration)
			if !character.character_controller.is_walking: continue
			SwitchState.emit(self, "walking")
			flag = true
		
		# Trường hợp sau vòng lặp mà không tìm được đường đi thì kết thúc lượt luôn
		character.turnbase_actor.emit_endturn("I stopped find wondering path")
		SwitchState.emit(self, "idle")
