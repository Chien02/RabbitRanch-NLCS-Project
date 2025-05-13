extends Node2D

class_name AnimalManager

enum Catcher {
	PLAYER,
	WOLF,
	DESTINATION
}

var animals : Array[Animal] = []
var eaten_animals = {}
var caughted_animals = {}
var max_animals : int = 0
var max_animal_score : int = 0

signal JustCaughtAnimal

func init_animals(level_manager: LevelManager):
	var temp = level_manager.get_tree().get_nodes_in_group("Animal")
	for child in temp:
		if child is Animal and child is not Wolf:
			animals.append(child)
	max_animals = animals.size()

func set_max_animal_score(value: int):
	max_animal_score = max(value, max_animals)

func get_animals():
	return animals

func caught_animal(body: Animal, catcher: int):
	var level_manager : LevelManager = body.get_tree().get_first_node_in_group("LevelManager")
	if level_manager.is_loss: return

	if animals.has(body):
		print("From AnimalManager: emit signal with ", body.resource.name)
		animals.erase(body)
		print("From AnimalManager: Erased ", body.name, " out of animals")
		if animals.is_empty():
			SlowmoController.slow_mo(0.2)
			await get_tree().create_timer(0.5).timeout
			SlowmoController.stop_slow_mo()
		
		match catcher:
			Catcher.PLAYER:
				JustCaughtAnimal.emit(body.resource.name)
				print("From AnimalManager: ", body.resource.name, " was caught by Player")
				caughted_animals[str(body.name.to_lower())] = {
					"name": body.name.to_lower(),
					"caught_by": catcher
				}
				
			Catcher.DESTINATION, Catcher.WOLF: 
				print("From AnimalManager: Added ", body.name, " to eaten animals")
				eaten_animals[str(body.name.to_lower())] = {
					"name": body.name.to_lower(),
					"caught_by": catcher
				}
		# Then release that animal out of scene
		body.queue_free()
		
		# Check win loss event
		if !animals.is_empty(): return
		if caughted_animals.size() < max_animal_score:
			print("-------------------From AnimalManager: Losssssss")
			level_manager.state = level_manager.State.LOSS
			return
		if caughted_animals.size() >= max_animal_score:
			print("-------------------From AnimalManager: Winnnnn")
			level_manager.state = level_manager.State.WIN
			return
