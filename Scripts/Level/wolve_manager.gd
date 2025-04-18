extends Node2D

class_name Wolve_Manager

var wolve : Array[Wolf] = []

signal WolfDisappeared

func init_wolve(level_manager: LevelManager):
	for node in level_manager.get_tree().get_nodes_in_group("Wolf"):
		if node is Wolf:
			wolve.append(node)
	print("From Wolve_M: number of wolve is ", wolve.size())

func get_wolve() -> Array[Wolf]:
	if !wolve.is_empty():
		for wolf in wolve:
			print("From Wolf_M: wolf at ", wolf.grid.local_to_map(wolf.position),".role = ", wolf.role)
	return wolve

func set_role():
	if wolve.is_empty():
		print("From Wolve_M: wolve is empty")
		return
	var distance : float = 0.0
	var min_distance : float = 99999.0
	var temp_gate_keeper : Wolf = null
	# Setting the gate keeper role for wolf
	for wolf in wolve:
		distance = calculate_distance(wolf, wolf.grid.destination)
		if distance < min_distance:
			min_distance = distance
			temp_gate_keeper = wolf
	# Set the f*cking role for the whole team
	temp_gate_keeper.role = Wolf.Role.GATE_KEEPER
	for wolf in wolve:
		if wolf.role == Wolf.Role.GATE_KEEPER: continue
		wolf.role = Wolf.Role.HUNTER

func calculate_distance(wolf: Wolf, _des: Vector2i) -> float:
	var wolf_pos = wolf.grid.local_to_map(wolf.position)
	var distance = sqrt(pow(wolf_pos.x - _des.x, 2) + pow(wolf_pos.y - _des.y, 2))
	return distance
