extends Control

class_name SlotUI

@export var input_key : String
@export var input_panel : PanelContainer
@export var texture_rect_slot : TextureRect
@export var texture_rect_item : TextureRect
@export var label : Label

func _ready() -> void:
	scale = Vector2.ZERO
	input_panel.visible = false
	label.text = input_key
