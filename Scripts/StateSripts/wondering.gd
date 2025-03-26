extends BaseState

class_name Wondering

enum {
	go_random,
	stay
}
var random_choice = -1

func enter_state():
	print(character.name, " enter wondering state")
	reset()

func exit_state():
	print(character.name, " exit wondering state")

func update_state():
	if random_choice != -1: return
	switch_to()

func reset():
	random_choice = -1

func switch_to():
	random_choice = randi_range(0, 2)
	match random_choice:
		go_random: switch_to_walk()
		stay: switch_to_idle()

func switch_to_idle():
	SwitchState.emit(self, "idle")
	if character is Animal:
		character.turnbase_actor.emit_endturn()

func switch_to_walk():
	if character is Animal:
		var duration = 0.5
		var neighbors = character.grid.get_surrounding_cells(character.grid.local_to_map(character.position))
		for neighbor in neighbors:
			if character.grid.cells.has(str(neighbor)):
				if character.grid.cells[str(neighbor)]["is_path"]:
					var next_pos = neighbor
					character.character_controller.move_to(character, next_pos, duration)
					if character.character_controller.is_walking:
						SwitchState.emit(self, "walking")
