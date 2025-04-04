extends Food

class_name Trap

@export var animation_player : AnimationPlayer
@export var area : Area2D

func _ready() -> void:
	if !animation_player: return
	if !is_selecting and character:
		animation_player.play("trap_open")
		is_activating = true
		print("From Trap: is ativating: ", is_activating)
	else: animation_player.play("trap_item")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter and !is_activating:
		print("From Trap: collide with Main Character")
		var new_item = Trap.new()
		new_item.init(grid, body, resource)
		body.inventory.add_item(new_item)
		disappear()
	elif is_activating:
		print("From Trap: collide with Animal")
		animation_player.play("trap_close")
		hold(body)

func hold(body: Node2D):
	if !body is Character: return
	var max_stunned_turn = 3
	# Disable Trap collider
	area.get_child(0).set_deferred("disabled", true)
	body.stunned(true, max_stunned_turn)
	body.OutOfStunned.connect(disappear)
	print("From Trap: Trapped ", body.name)

func _input(event: InputEvent) -> void:
	if !is_selecting and character != null:
		character.is_look_at_mouse = false
		return
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_pos = get_global_mouse_position()
		var local_mouse_pos = grid.local_to_map(mouse_pos)
		print("From Trap: mouse position is ", local_mouse_pos)
		
		if !throwable_slot.has(local_mouse_pos): return
		print("From Trap: Selected position is ", local_mouse_pos)
		# Let character stop look at the mouse
		character.facing_direction = character.get_local_mouse_position()
		# Turn off these flags
		character.is_look_at_mouse = false
		is_selecting = false
		# Do the thing
		var localize_position = grid.map_to_local(local_mouse_pos)
		throw_item(localize_position)
		grid.clear_layer(debug_layer)

func active():
	if is_selecting: return
	is_selecting = true # If player move or press key ESC then cancel
	character.is_look_at_mouse = true
	print("From Trap: Activate Trap")
	print("From Trap: Active Trap is_selecting: ", is_selecting)
#	Generate zone that player can throw item
	throwable_zone()
#	Let character look at the mouse and play look at animation
	set_process(is_selecting)
	set_process_input(is_selecting)

func throw_item(pos: Vector2):
	print("From Trap: throwed trap at ", pos)
	# Create new instance of this item
	character.inventory.drop_item(self, pos)
