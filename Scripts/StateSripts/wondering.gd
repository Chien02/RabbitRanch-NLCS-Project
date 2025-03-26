extends BaseState

class_name Wondering

var random_choice = -1

func enter_state():
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
		character.turnbase_actor.emit_endturn()

func switch_to_walk():
	if character is Animal:
		var duration = 0.5
		var neighbors : Array[Vector2i] = character.grid.get_surrounding_cells(character.grid.local_to_map(character.position))
		var flag : bool = false
		while (flag == false):
			var index = randi_range(0, neighbors.size()-1)
			print("random number is : ", index)
			if character.grid.is_within_grid(neighbors[index]):
				if character.grid.is_path(neighbors[index]):
					var next_pos = character.grid.map_to_local(neighbors[index])
					print("Wondering state: go random to next_pos: ", next_pos)
					character.character_controller.move_to(character, next_pos, duration)
					if character.character_controller.is_walking:
						SwitchState.emit(self, "walking")
						flag = true
