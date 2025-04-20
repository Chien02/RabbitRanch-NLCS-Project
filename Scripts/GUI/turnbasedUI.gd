extends Control

class_name TurnBasedUI

@export var character_name : String
@export var texture : CompressedTexture2D # Represent character's icon
@export var texture_rect_base : NinePatchRect
@export var step : int

@export var texture_rect : TextureRect
@export var label : Label

var active_base_ui : String = "res://Sprites/Sprout Lands - UI Pack - Basic pack/Sprite sheets/active_actor.png"
var inactive_base_ui : String = "res://Sprites/Sprout Lands - UI Pack - Basic pack/Sprite sheets/inactive_actor.png"

func init(_character_name: String, _texture: CompressedTexture2D, _step: int):
	character_name = _character_name
	texture_rect.texture = _texture
	label.text = str(_step)

func set_color(status: int):
	match status:
		TurnBasedManager.ACTIVE: texture_rect_base.texture = load(active_base_ui)
		TurnBasedManager.INACTIVE: texture_rect_base.texture = load(inactive_base_ui)

func clear_property():
	texture = null
	step = 0
	character_name = ""
