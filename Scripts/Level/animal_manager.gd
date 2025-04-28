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

signal JustCaughtAnimal

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
	
	# Điều kiện thắng thua, thắng miễn là có bắt được toàn bộ con vật còn lại trên sân
	# Ngược lại, nếu con vật trên sân đã biến mất hết mà eatan_animal khong rỗng thì coi như thua
	if animals.is_empty() and !caughted_animals.is_empty() and eaten_animals.size() < max_animals:
		level_manager.Win.emit()
	elif animals.is_empty() and !eaten_animals.is_empty():
		level_manager.Loss.emit()

func caught_animal(body: Animal, catcher: int):
	var level_manager : LevelManager = body.get_tree().get_first_node_in_group("LevelManager")
	if animals.has(body):
		print("From AnimalManager: emit signal with ", body.resource.name)
		animals.erase(body)
		print("From AnimalManager: Erased ", body.name, " out of animals")
		
		match catcher:
			Catcher.PLAYER:
				JustCaughtAnimal.emit(body.resource.name)
				print("From AnimalManager: ", body.resource.name, " was caught by Player")
				caughted_animals[str(body.name.to_lower())] = {
					"name": body.name.to_lower(),
					"caught_by": catcher
				}
			Catcher.DESTINATION, Catcher.WOLF: 
				eaten_animals[str(body.name.to_lower())] = {
					"name": body.name.to_lower(),
					"caught_by": catcher
				}
		
		print("From AnimalManager: Added ", body.name, " to eaten animals")
		
		# Then release that animal out of scene
		body.queue_free()
		# Check loss event
		if animals.is_empty():
			if eaten_animals.size() > (max_animals/2.0) and caughted_animals.size() < max_animals/2.0:
				print("-------------------From AnimalManager: Losssssss")
				level_manager.Loss.emit()
				return
			if eaten_animals.size() < max_animals and caughted_animals.size() >= max_animals/2.0:
				print("-------------------From AnimalManager: Winnnnn")
				level_manager.Win.emit()
				return
			
