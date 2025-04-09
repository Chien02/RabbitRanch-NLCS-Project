extends Control

class_name FootStep

@export var label : Label
@export var foot_step_texure : TextureRect
@export var red_food_step_texure : CompressedTexture2D
@export var green_food_step_texture : CompressedTexture2D

func change_text(text: String):
	if !label: return
	label.text = text

func change_texture(texture_name: String):
	match texture_name:
		"red_footstep": foot_step_texure.texture = red_food_step_texure
		"green_footstep": foot_step_texure.texture = green_food_step_texture
