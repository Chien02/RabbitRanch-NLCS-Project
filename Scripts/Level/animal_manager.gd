extends Node2D

class_name AnimalManager

enum Catcher {
	PLAYER,
	WOLF,
	DESTINATION
}

var animals : Array[Animal] = []
var eaten_animals = {}
var max_animals : int = 0

func init_animals(level_manager: LevelManager):
	var temp = level_manager.get_tree().get_nodes_in_group("Animal")
	for child in temp:
		if child is Animal and child is not Wolf:
			animals.append(child)
	max_animals = animals.size()

func get_animals():
	return animals

func check_animal_on_field(level_manager: LevelManager):
	for animal in animals:
		if animal == null:
			animals.erase(animal)
	
	if animals.is_empty() and eaten_animals.size() < max_animals:
		level_manager.Win.emit()
	elif animals.is_empty() and !eaten_animals.is_empty():
		level_manager.Loss.emit()

func caught_animal(body: Animal, catcher: int):
	var level_manager : LevelManager = body.get_tree().get_first_node_in_group("LevelManager")
	if animals.has(body):
		animals.erase(body)
		print("From AnimalManager: Erased ", body.name, " out of animals")
		if catcher == Catcher.PLAYER: return
		eaten_animals[str(body.name.to_lower())] = {
			"name": body.name.to_lower(),
			"caught_by": catcher
		}
		print("From AnimalManager: Added ", body.name, " to eaten animals")
		
		# Then release that animal out of scene
		body.queue_free()
		# Check loss event
		if !eaten_animals.is_empty() and animals.is_empty():
			level_manager.Loss.emit()
	
	if animals.is_empty() and eaten_animals.size() < max_animals:
		level_manager.Win.emit()
