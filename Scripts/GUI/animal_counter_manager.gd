extends Control

class_name AnimalCounterManager

# Properties
var cows : Array[Animal] = []
var chickens : Array[Animal] = []
# Components
var animals_manager : AnimalManager

# Methods
func _process(_delta: float) -> void:
	if !animals_manager:
		init_UI_bars()
	
	# Lấy số lượng current của mỗi loại trong caught animals
	#if !cows.is_empty() or !chickens.is_empty():
		#var cow_counter : int = 0
		#var chicken_counter : int = 0
		#
		#for animal in animals_manager.caughted_animals:
			#match animals_manager.caughted_animals[animal]["name"]:
				#"cow":
					#print("From AnimalCounterManager: add one cow, counter = ", cow_counter)
					#cow_counter += 1
				#"chicken":
					#print("From AnimalCounterManager: add one chicken, counter = ", chicken_counter)
					#chicken_counter += 1
		#
		#var ui_bars := get_children()
		#for ui_bar in ui_bars:
			#match ui_bar.category.to_lower():
				#"cow": ui_bar.set_label(cow_counter, ui_bar.max_counter)
				#"chicken": ui_bar.set_label(chicken_counter, ui_bar.max_counter)

func init_UI_bars():
	animals_manager = get_tree().get_first_node_in_group("LevelManager").animals_manager
	animals_manager.JustCaughtAnimal.connect(_on_just_caught_animal)
	# Lấy số lượng animals hiện tại, kiểm tra xem có bao nhiêu loại trên sân
	# Sau đó sinh ra số lượng UI BAR theo số lượng được phân loại
	var animals : Array[Animal] = animals_manager.animals
	
	for animal in animals:
		match animal.resource.name.to_lower():
			"cow": cows.append(animal)
			"chicken": chickens.append(animal)
		
	# Kiểm tra phân loại nào có số lượng lớn hơn 0 thì mới sinh ra
	# Lấy số lượng max (max = size()) và current = số lượng animals còn trong sân
	if !cows.is_empty():
		print("From AnimalCounterUI: cow caterory with size: ", cows.size())
		var new_ui = add_UI_bar(cows[0].resource.name, cows[0].resource.texture, cows.size())
		call_deferred("add_child", new_ui)
		
	if !chickens.is_empty():
		print("From AnimalCounterUI: chicken caterory with size: ", chickens.size())
		var new_ui = add_UI_bar(chickens[0].resource.name, chickens[0].resource.texture, chickens.size())
		call_deferred("add_child", new_ui)

func add_UI_bar(animal_name: String, texture: CompressedTexture2D, _max: int, _current: int = 0) -> AnimalCounterUI:
	var new_ui_bar : AnimalCounterUI = preload("res://Scenes/GUI/animal_counter_UI.tscn").instantiate()
	new_ui_bar.max_counter = _max
	new_ui_bar.set_category(animal_name)
	new_ui_bar.set_texture(texture)
	new_ui_bar.set_label(_current, _max)
	return new_ui_bar

func _on_just_caught_animal(animal_name: String):
	("From AnimalCounterManager: connect with JustCaughtAnimal")
	for ui_bar in get_children():
		match ui_bar.category:
			"cow":
				if animal_name == ui_bar.category:
					print("From AnimalCounterManager: add one cow")
					ui_bar.set_label(ui_bar.current_counter + 1, ui_bar.max_counter)
			"chicken":
				if animal_name == ui_bar.category:
					("From AnimalCounterManager: add one chicken")
					ui_bar.set_label(ui_bar.current_counter + 1, ui_bar.max_counter)
		
