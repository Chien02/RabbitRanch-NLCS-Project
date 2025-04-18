extends Control

class_name AnimalCounterUI

@export var category : String = ""
@export var label  : Label
@export var texture_rect : TextureRect
@export var max_counter : int = 0
var current_counter : int = 0

func set_category(animal_name: String):
	category = animal_name

func set_texture(texture: CompressedTexture2D):
	texture_rect.texture = texture

func set_label(current: int, _max: int):
	current_counter = current
	max_counter = _max
	label.text = str(current_counter) + "/" + str(max_counter)
