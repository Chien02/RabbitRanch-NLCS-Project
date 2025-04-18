extends PanelContainer

class_name TurnBasedUI

@export var character_name : String
@export var texture : CompressedTexture2D # Represent character's icon
@export var step : int

@export var texture_rect : TextureRect
@export var label : Label

func _ready() -> void:
	var shared_stylebox = get("theme_override_styles/panel")
	# Tạo một bản sao độc lập
	var unique_stylebox = shared_stylebox.duplicate()
	# Gán lại để control dùng bản sao này
	add_theme_stylebox_override("panel", unique_stylebox)

func init(_character_name: String, _texture: CompressedTexture2D, _step: int):
	character_name = _character_name
	texture_rect.texture = _texture
	label.text = str(_step)

func set_color(new_color: Color):
	get("theme_override_styles/panel").bg_color = new_color

func clear_property():
	texture = null
	step = 0
	character_name = ""
