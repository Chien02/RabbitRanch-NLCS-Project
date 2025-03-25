extends Idle

class_name IdleAnimal

var paths : Array[TilePath] = []
var flag : bool = false

func enter_state():
	flag = false
	print("IdleAnimal: --- mode: ", character.mode, " option: ", character.option)

func exit_state():
	character.grid.clear_layer(4)

func update_state(): # Overriding
	if character is Animal:
		if !character.turnbase_actor.is_active or flag: return
		if character.is_finished_special: return
		finding_path()
	
	if paths.is_empty():
		print("From idle animal: Could not find the paths") # For debugging
	
	elif !paths.is_empty() and !flag:
		if character is Animal:
			if not character.is_option_ignore():
				check_next_step()
		
		# For debugging
		for path in paths:
			#print(path.position, " is_path: ", path.is_path)
			character.grid.get_child(4).set_cell(path.position, 3, Vector2i(0, 0))
		flag = true # Turn on flag for stopping the loop of find path
	
	# Check the next step is a breakable object or not
	# If it's true then switch to special state, else just ignore it

func finding_path():
	if character is Animal:
		var animal = character
		paths = animal.astar.get_the_path(animal.option, animal.mode)

func check_next_step():
	if paths.is_empty() or flag: return
	
	var next_tile_index : int = paths.size()-2
	var next_tile : TilePath = paths[next_tile_index]
	
	var obs_manager : ObstacleManagement = get_tree().get_first_node_in_group("ObsManager")
	for obs in obs_manager.obstacles:
		if obs:
			if next_tile.position == obs.local_position and obs.is_breakable():
				print("Animal Idle: next_tile", obs.local_position," is breakable: ", obs.is_breakable())
				character.breakable_obstacle = obs
				SwitchState.emit(self, "special")
