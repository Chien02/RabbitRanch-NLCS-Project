extends BaseState

class_name WolfWalking

var step : int = 2
var walking_flag : bool = false

func enter_state():
	print("From Wolf Walking: ", character.name, " enter walking state")
	if character.charge_point > character.paths.size():
		character.charge_point = character.paths.size() - 1
	elif character.charge_point == 0:
		character.charge_point = 1
	step = 2
	walking_flag = false

func exit_state():
	print("From Wolf Walking: ", character.name, " exit walking state")

func update_state():
	pass

func physics_update():
	# Both main character and animal
	if !character.character_controller.is_walking and character.charge_point == 0:
		print("From Wolf Walking: Switch to idle")
		SwitchState.emit(self, "idle")
		character.turnbase_actor.emit_endturn()
	
	if walking_flag: return
	walking_flag = true
	var duration : float = 0.5
	
	for index in range(0, character.charge_point):
		var next_index = clamp(character.paths.size() - step, 0, character.paths.size() - step)
		var next_pos = character.grid.map_to_local(character.paths[next_index].position)
		await character.character_controller.move_to(character, next_pos, duration)
		step += 1
	character.charge_point = 0
	
func charge_walk():
	var duration = 0.5
	for index in range(0, character.charge_point):
		var next_pos = character.grid.map_to_local(character.paths[character.paths.size() - step].position)
		# Kiểm tra tile tiếp theo, nếu như là animal thì dừng lại không đi tiếp nữa mà thực chuyển qua bitting luôn
		check_to_bite(next_pos)
		character.character_controller.move_to(character, next_pos, duration)
		step += 1
	
	var next_pos = character.facing_direction + character.grid.tile_size * Vector2.ONE
	print("From Wolf Walking: Check next pos after walking at ", next_pos)
	check_to_bite(next_pos)
	character.charge_point = 0

func check_to_bite(next_pos: Vector2i):
	var animals_manager : AnimalManager= get_tree().get_first_node_in_group("LevelManager").animals_manager
	for animal in animals_manager.animals:
		if character.grid.map_to_local(animal.position) == next_pos:
			print("From Wolf Walking: Next position is animal, then bite")
			SwitchState.emit(self, "bitting")
			character.charge_point = 0
