extends Item

class_name Axe

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter:
		print("From Item: collide with Main Character")
		var new_axe = Axe.new()
		new_axe.init(grid, body, resource)
		body.inventory.add_item(new_axe)
		disappear()

func active():
	if is_activating: return
	is_activating = true
	var facing_direction = Vector2i(character.facing_direction)
	print("From Axe: facing direction is ", facing_direction)
	var character_pos = grid.local_to_map(character.position)
	print("From Axe: character_pos is ", character_pos)
	var local_pos = character_pos + facing_direction
	print("From Axe: local_pos is ", local_pos)
	check_local_pos(local_pos)

func check_local_pos(local_pos: Vector2i):
	if !grid.is_within_grid(local_pos):
		is_activating = false
		return
	if !grid.is_path(local_pos):
		for obstacle in grid.obstacles_management.obstacles:
			if obstacle == null: continue
			if obstacle.local_position != local_pos: continue
			if !obstacle.is_breakable(): continue
			if obstacle is Obstacle:
				character.inventory.UsingItem.emit(resource.name.to_lower())
				obstacle.destroy(resource.duration, character)
				print("From Axe: Destroyed this obstacle")
				await character.get_tree().create_timer(resource.duration).timeout
				character.tooling = false
				is_activating = false
	is_activating = false
