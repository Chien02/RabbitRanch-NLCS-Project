extends AnimalCounterManager

@export var vbox : VBoxContainer

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
		#print("From AnimalCounterUI: cow caterory with size: ", cows.size())
		var new_ui = add_UI_bar(cows[0].resource.name, cows[0].resource.texture, cows.size())
		vbox.call_deferred("add_child", new_ui)
	
	if !chickens.is_empty():
		#print("From AnimalCounterUI: chicken caterory with size: ", chickens.size())
		var new_ui = add_UI_bar(chickens[0].resource.name, chickens[0].resource.texture, chickens.size())
		vbox.call_deferred("add_child", new_ui)


func _on_just_caught_animal(animal_name: String):
	#print("From AnimalCounterManager: connect with JustCaughtAnimal")
	var ui_bars = get_node("VBoxContainer").get_children()
	for ui_bar in ui_bars:
		#print("From AnimalCounterManager: ui_bar.category: ", ui_bar.category)
		match ui_bar.category.to_lower():
			"cow":
				if animal_name.to_lower() == ui_bar.category.to_lower():
					#print("From AnimalCounterManager: add one cow")
					ui_bar.set_label(ui_bar.current_counter + 1, ui_bar.max_counter, level_manager)
					return
			"chicken":
				if animal_name.to_lower() == ui_bar.category.to_lower():
					#print("From AnimalCounterManager: add one chicken")
					ui_bar.set_label(ui_bar.current_counter + 1, ui_bar.max_counter, level_manager)
					return
	#print("From AnimalCounterManager: cannot find animal_name: ", animal_name.to_lower())
