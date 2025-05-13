extends Control

class_name AnimalCounterUI

@export var category : String = ""
@export var max_score_label  : Label
@export var current_score_label : Label
@export var texture_rect : TextureRect
@export var max_counter : int = 0

var current_counter : int = 0

func set_category(animal_name: String):
	category = animal_name

func set_texture(texture: CompressedTexture2D):
	texture_rect.texture = texture

func set_label(current: int, _max: int, level_manager: LevelManager):
	var dark_green = "6e967c"
	var dark_red = "90625d"
	
	current_counter = current
	max_counter = _max
	current_score_label.text = str(current_counter)
	max_score_label.text = "/ " + str(max_counter)
	
	# Set color of max_score
	max_score_label["theme_override_colors/font_color"] = Color(dark_red)
	
	# Change color of current_score
	if current_counter >= level_manager.suitable_score:
		current_score_label["theme_override_colors/font_color"] = Color(dark_green)
		max_score_label["theme_override_colors/font_color"] = Color(dark_green)
	else:
		current_score_label["theme_override_colors/font_color"] = Color(dark_red)
