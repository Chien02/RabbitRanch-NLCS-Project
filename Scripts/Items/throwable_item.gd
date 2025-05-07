extends Item

class_name ThrowableItem

var is_selecting : bool = false
var throwable_slot : Array[Vector2i] = []
var debug_layer : int = Grid.DESTINATION
var selecting_pos : Vector2 = Vector2.ZERO

func _ready() -> void:
	is_selecting = false
	is_activating = false

func activating_update(_delta: float) -> void:
	if !is_activating: return
	cancel_handling()
	selecting_tile()


func cancel_handling():
	# Return when it already false
	if !is_selecting: return
	
	# Case 1: player walks while selecting
	if character.character_controller.is_walking and is_selecting:
		is_selecting = false
		print("From ", name, ": Stop selecting tile")
		# Remember to clear the map
		character.grid.clear_layer(debug_layer)
	
	# Case 2: player cancel the process
	elif Input.is_action_just_pressed("cancel"):
		is_selecting = false
		print("From ", name, ": Stop selecting tile")
		# Remember to clear the map
		character.grid.clear_layer(debug_layer)


func let_player_lookat_selecting_tile(selecting_tile_pos: Vector2):
	if !is_selecting: return
	character.facing_direction = (selecting_tile_pos - character.position).normalized()
	#print("From ", name, ": looking direction: ", character.facing_direction)


func selecting_tile():
	if !is_selecting: return
	# Case 1: Keyboard Input
	# Display the position that mouse is selecting
	var temp_global_mouse_pos : Vector2 = grid.get_global_mouse_position()
	var mouse_local_pos : Vector2i = grid.local_to_map(temp_global_mouse_pos)
	
	# Case 2: Gamepad Input
	# I'm sorry but I can afford it :((
	
	if !throwable_slot.has(mouse_local_pos):
		return
	#print("From ", name, ": Selected at ", mouse_local_pos)
	var green_mouse_id : int = 2
	grid.get_child(Grid.PLAYER_ZONE).set_cell(mouse_local_pos, green_mouse_id, Vector2i.ZERO)
	
	selecting_pos = temp_global_mouse_pos
	let_player_lookat_selecting_tile(selecting_pos)
	
	
	if Input.is_action_just_pressed("mouse_left"):
		# Check the mouse location once again
		if !throwable_slot.has(mouse_local_pos):
			print("From ", name, ": This spot: ", mouse_local_pos, " is illegal")
			return
		
		# Legit!, then just call the throw method
		# Then stop selecting tile
		print("From ", name, ": Selected at ", mouse_local_pos)
		throw_item(selecting_pos)
		is_selecting = false
		
		# Remember to clear the grid
		grid.clear_layer(debug_layer)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter and !is_activating: # item state
		print("From Rice: collide with Main Character")
		# play audio
		if audio:
			audio.play_sound(CharacterSoundFX.Sound.COLLECT)
		
		var new_item : ThrowableItem = load(resource.link).instantiate()
		new_item.init(grid, body, resource)
		body.inventory.add_item(new_item)
	elif body is Animal: # Do not thing when animal collide when it's in item state
		print("From Rice: collide with Animal")
	disappear()

func active():
	if is_activating: return
	is_selecting = true # If player move or press key ESC then cancel
	is_activating = true
	print("From ", name, ": Activate")
	print("From ", name, ": Active is_selecting: ", is_selecting)
#	// Generate zone that player can throw item
	set_process(is_activating)
	generate_throwable_zone()


func generate_throwable_zone():
	print("From ", name,": Generate throwable zone")
	# In case that player receive this item from a chest, then the grid is not in this item first
	if grid == null:
		grid = character.get_tree().get_first_node_in_group("Grid")
	
	print("From Throwable item: ", name, " : player position is: ", character.local_position)
	
	var max_x = min(character.local_position.x + 3, grid.max_x_size)
	var max_y = min(character.local_position.y + 3, grid.max_y_size)
	var min_x = max(character.local_position.x - 2, 0)
	var min_y = max(character.local_position.y - 2, 0)
	
	for x in range(min_x, max_x):
		for y in range(min_y, max_y):
			if !grid.is_within_grid(Vector2i(x, y)): continue
			if !grid.is_path(Vector2i(x, y)): continue
			throwable_slot.append(Vector2i(x, y))
			
			# for debug:
			var select_cursor_id : int = 4
			grid.get_child(Grid.DESTINATION).set_cell(Vector2i(x, y), select_cursor_id, Vector2i(0, 0))
	
	# For debug
	print("From Throwable_item: ", name, " throwable_zone : ")
	print("From Throable_item: ", name, " throwable_slots: ", throwable_slot)


func _on_obstacle_destroyed(local_pos: Vector2i):
	print("From Obstacle: Connected with obstacle, rescan throwable zone")
	throwable_slot.append(local_pos)


func throw_item(pos: Vector2):
	print("From Food: thrown item in ", pos)
	# Create new instance of this item
	# Convert global position to local, then get the local position
	var local_pos : Vector2i = grid.local_to_map(pos)
	var converted_global_pos : Vector2 = grid.map_to_local(local_pos)
	character.inventory.drop_item(self, converted_global_pos)
	finish_active()

func max_vectori(a: Vector2i, b: Vector2i):
	if a > b: return a
	return b

func min_vectori(a: Vector2i, b: Vector2i):
	if a < b: return a
	return a
