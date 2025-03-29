extends Control

class_name SlotUI

@export var input_key : String
var slot_panel : PanelContainer
var input_panel : PanelContainer
var texture_rect : TextureRect
var label : Label

func _ready() -> void:
	slot_panel = get_node("SlotPanelContainer")
	input_panel = get_node("InputPanelContainer")
	texture_rect = get_node("SlotPanelContainer/TextureRect")
	label = get_node("InputPanelContainer/Label")
	
	slot_panel.scale = Vector2.ZERO
	input_panel.visible = false
	label.text = input_key
