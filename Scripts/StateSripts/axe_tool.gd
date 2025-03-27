extends Tooling

class_name Axe

func enter_state():
	tooling = false
	print("From Axe: Enter axe state")

func exit_state():
	print("From Axe: Exit axe state")

func update_state():
	check_facing_object()
	check_for_switch()

func check_for_switch():
	if tooling and !character.is_tooling():
		print("From Axe: switch to idle state")
		SwitchState.emit(self, "idle")

func check_facing_object():
	if character is MainCharacter and !tooling:
		# Turn on the flag
		tooling = true
		
		var next_pos : Vector2i = character.grid.local_to_map(character.position) + Vector2i(character.facing_direction)
		if character.grid.is_path(next_pos):
			print("From Axe: The next position is not an obstacle")
			finished_tool()
			return
		print("From Axe: The next position is an obstacle")
		for obstacle in character.grid.obstacles_management.obstacles:
			if next_pos == obstacle.local_position:
				print("From Axe: The next position is a breakable obstacle")
				do_tooling(obstacle)

func do_tooling(obstacle: Obstacle):
	var duration : float = 1.0
	
	if !obstacle.is_breakable():
		print("From Axe: This obstacle cannot be break at ", obstacle.local_posittion)
		finished_tool()
		return
	
	tooling = true
	character.tooling = tooling
	obstacle.destroy(duration)
	print("From Axe: Destroy this obstacle")
	await get_tree().create_timer(duration).timeout
	finished_tool()
	print("From Axe: Out of time, finish tool, character's tooling: ", character.is_tooling())

func finished_tool():
	character.tooling = false
