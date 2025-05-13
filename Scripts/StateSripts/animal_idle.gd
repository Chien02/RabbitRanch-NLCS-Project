extends Idle

class_name IdleAnimal

var paths : Array[TilePath] = []
var find_path_flag : bool = false
var do_special: bool = false

func _ready() -> void:
	if !character:
		print("From Animal no name Idle: Cannot connect to character")
		return
	if character.is_in_group("Wolf"):
		character.health.Hurted.connect(_switch_to_hurt)
		character.health.Died.connect(_switch_to_die)

func enter_state(_value: Node2D = null):
	find_path_flag = false
	character.grid.rescan()
	print("From ", character.name," Idle: Enter Idle state")

func exit_state():
	character.grid.clear_layer(4)
	print("From ", character.name," Idle: Exit Idle state")

func update_state(): # Overriding
	if !character.turnbase_actor.is_active or find_path_flag:
		return
	if character.is_stun:
		character.turnbase_actor.emit_endturn(" I'm get stunned")
		return
	if character.be_caught:
		character.turnbase_actor.emit_endturn(" I'm get caught")
		return
	finding_path()
	
	if paths.is_empty():
		print("From ", character.name," Idle: Could not find the paths") # For debugging
		SwitchState.emit(self, "wondering")
		return
	
	# If it's not ignore that means it want to break something it's facing
	# Else just walk and not check
	match character.is_option_ignore():
		true: switch_to_walk()
		false: check_next_step()

	find_path_flag = true

func switch_to_walk():
	var duration = 0.5
	if paths.is_empty():
		print("From ", character.name, " Idle : Cannot switch to walk")
		character.turnbase_actor.emit_endturn("I couldn't walk because paths is empty")
	
	if character is not Wolf:
		var next_pos = character.grid.map_to_local(paths[paths.size() - 2].position)
		character.character_controller.move_to(character, next_pos, duration)
		if character.character_controller.is_walking:
			SwitchState.emit(self, "walking")


func finding_path():
	paths.clear()
	paths = character.astar.get_the_path(character.option, character.mode)

func check_next_step():
	if paths.is_empty() or find_path_flag: return
	
	var next_tile_index : int = paths.size()-2
	var next_tile : TilePath = paths[next_tile_index]
	var temp_obs : Obstacle = null
	
	var obs_manager : ObstacleManagement = get_tree().get_first_node_in_group("ObsManager")
	for obs in obs_manager.obstacles:
		if obs:
			if next_tile.position == obs.local_position and obs.is_breakable():
				temp_obs = obs
				print("From ", character.name," Idle: next_tile", obs.local_position," is breakable: ", obs.is_breakable())
				character.breakable_obstacle = obs
				SwitchState.emit(self, "special")
	if temp_obs == null:
		switch_to_walk()

func _switch_to_hurt():
	# Turn off all flag
	find_path_flag = true
	SwitchState.emit(self, "hurting")

func _switch_to_die():
	find_path_flag = true
	# Actually do nothing in here 'cause

func get_surrounding_zone():
	var local_pos = character.grid.local_to_map(character.position)
	var min_local = local_pos + Vector2i(-1, -1)
	var max_local = local_pos + Vector2i(2, 2)
	var surrounding_zone : Array[Vector2i] = []
	
	# Init the zone, it must be recreate every single turn
	for x in range(min_local.x, max_local.x):
		for y in range(min_local.y, max_local.y):
			surrounding_zone.append(Vector2i(x, y))
	
	return surrounding_zone
