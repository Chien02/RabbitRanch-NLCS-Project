extends Idle

class_name IdleAnimal

var paths : Array[TilePath] = []
var flag : bool = false
var do_special: bool = false

func enter_state():
	flag = false
	character.grid.rescan()
	print("-----From Animal Idle: Enter Idle state")

func exit_state():
	character.grid.clear_layer(4)
	print("From Animal Idle: Exit Idle state")

func update_state(): # Overriding
	if character is Animal:
		if !character.turnbase_actor.is_active or flag:
			return
	
	finding_path()
	if paths.is_empty():
		print("From idle animal: Could not find the paths") # For debugging
		SwitchState.emit(self, "wondering")
	
	elif !paths.is_empty():
		if character is Animal:
			if not character.is_option_ignore():
				check_next_step()
			else:
				switch_to("walking")
		# For debugging
		flag = true # Turn on flag for stopping the loop of find path
	
	# Check the next step is a breakable object or not
	# If it's true then switch to special state, else just ignore it

func switch_to(state_name: String):
		var duration = 0.5
		var next_pos = character.grid.map_to_local(paths[paths.size() - 2].position)
		if character is Animal:
			character.character_controller.move_to(character, next_pos, duration)
			if character.character_controller.is_walking:
				SwitchState.emit(self, state_name)

func finding_path():
	paths.clear()
	if character is Animal:
		var animal = character
		paths = animal.astar.get_the_path(animal.option, animal.mode)

func check_next_step():
	if paths.is_empty() or flag: return
	
	var next_tile_index : int = paths.size()-2
	var next_tile : TilePath = paths[next_tile_index]
	var temp_obs : Obstacle = null
	
	var obs_manager : ObstacleManagement = get_tree().get_first_node_in_group("ObsManager")
	for obs in obs_manager.obstacles:
		if obs:
			if next_tile.position == obs.local_position and obs.is_breakable():
				temp_obs = obs
				print("Animal Idle: next_tile", obs.local_position," is breakable: ", obs.is_breakable())
				character.breakable_obstacle = obs
				SwitchState.emit(self, "special")
	if temp_obs == null:
		switch_to("walking")
