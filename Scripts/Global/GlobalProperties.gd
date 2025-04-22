extends Node2D

# GLOBAL_PROPERTIES

# For the current level
var max_level : int = 0
var current_level : int = -1
var completed_level : Array[int] = []
var unlocked_level : Array[int] = []

# For the item
var inventory_items : Array[Item]

# For positions of all character
# {
	#"position": character.position,
	#"local_position": character.local_position,
	#"health": character.health.current_health
#}
var characters : Array[Character] = []
var characters_properties = {}

# For obstacles in the field
# {
	#"obstacle": obstacle,
	#"position": obstacle.position,
	#"local_position": obstacle.local_position,
#}
var obstacles : Array[Obstacle]
var obstacles_properties = {}

func save(scene_tree: SceneTree):
	# Lưu lại tất cả nhân vật trên sân
	var temps = scene_tree.get_nodes_in_group("Character")
	for temp in temps:
		if temp is not Character: continue
		characters.append(temp)
	
	# Lưu danh sách vật cản
	temps = scene_tree.get_nodes_in_group("Obstacle")
	for temp in temps:
		if temp is not Obstacle: continue
		obstacles.append(temp)
	
	# Lưu lại các thông số của từng nhân vật
	for character in characters:
		characters_properties[character.name] = {
			"position": character.position,
			"local_position": character.local_position,
			"current_health": character.health.current_health,
		}
	
	# Luư lại thông số của các vật cản
	for obstacle in obstacles:
		obstacles_properties[obstacle.name] = {
			"position": obstacle.global_position,
			"local_position": obstacle.local_position,
		}

func load(scene_tree: SceneTree):
	if characters.is_empty(): return
	var turnbased_manager : TurnBasedManager = scene_tree.get_first_node_in_group("TurnBasedManager")
	var obstacles_manager : ObstacleManagement = scene_tree.get_first_node_in_group("ObsManager")
	
	turnbased_manager.actor = characters
	obstacles_manager.obstacles = obstacles
	
	for child in turnbased_manager.actor:
		if characters_properties.has(child.name):
			scene_tree.print("From Global: load ", child.name)
			child.position = characters_properties[child.name]["position"]
			child.local_position = characters_properties[child.name]["local_position"]
			child.health.current_position = characters_properties[child.name]["current_health"]
		else:
			scene_tree.print("From Global: cannot get ", child.name, " to load")
	
	for obstacle in obstacles_manager.obstacles:
		if obstacles_properties.has(obstacle.name):
			scene_tree.print("From Global: load ", obstacle.name)
			obstacle.global_position = obstacles_properties[obstacle.name]["position"]
			obstacle.local_position = obstacles_properties[obstacle.name]["local_position"]
		else:
			scene_tree.print("From Global: cannot get ", obstacle.name, " to load")

func save_level(_current_level: int):
	current_level = _current_level

func load_level() -> int:
	return current_level

func complete_level(_current_level: int):
	completed_level.append(_current_level)
