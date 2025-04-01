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
	var facing_direction = Vector2i(character.facing_direction)
	print("From Axe: facing direction is ", facing_direction)
	var character_pos = grid.local_to_map(character.position)
	print("From Axe: character_pos is ", character_pos)
	var local_pos = character_pos + facing_direction
	print("From Axe: local_pos is ", local_pos)
	check_local_pos(local_pos)

func check_local_pos(local_pos: Vector2i):
	if !grid.is_within_grid(local_pos): return
	if !grid.is_path(local_pos):
		for obstacle in grid.obstacles_management.obstacles:
			if !obstacle: return
			if obstacle.local_position != local_pos: continue
			if !obstacle.is_breakable(): continue
			if obstacle is Obstacle:
				obstacle.destroy(resource.duration)
				print("From Axe: Destroyed this obstacle")
				await character.get_tree().create_timer(resource.duration).timeout
				grid.rescan(character.player_zone)
