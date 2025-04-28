extends Control

class_name SlotUI

@export var pc_input_key : String
@export var gamepad_input_key : String = "X"
@export var input_panel : PanelContainer
@export var texture_rect_slot : TextureRect
@export var texture_rect_item : TextureRect
@export var label : Label


func _ready() -> void:
	scale = Vector2.ZERO
	input_panel.visible = false
	label.text = pc_input_key

func change_input_to(is_gamepad: bool):
	label.text = gamepad_input_key if is_gamepad else pc_input_key
