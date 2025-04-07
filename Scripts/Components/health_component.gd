extends Node2D

class_name Health

@export_category("UI Components")
@export var heart_textures : Array[Sprite2D]
@export var health_resource : HealthResource

@export_category("Properties")
@export var max_health : int = 30
var current_health : int

signal Died
signal Hurted

func _ready() -> void:
	current_health = max_health

func damage(value: int):
	current_health -= abs(value)
	check_ui_heal(value)
	
	if current_health <= 0:
		current_health = 0
		Died.emit()
	elif current_health in range(0, max_health):
		Hurted.emit()

func heal(value: int):
	current_health += abs(value)
	if current_health >= max_health:
		current_health = max_health

func check_ui_heal(_damage: int):
	if heart_textures.is_empty():
		print("From ", get_parent().name, ": heart_textures is empty")
		return
	
	var step : int = int(_damage / 5)
	var duration : float = 0.25
	var pop_up_position : Vector2 = Vector2(0, -4)
	for index in range(0, step):
		for jndex in range(heart_textures.size() - 1, -1, -1):
			if heart_textures[jndex].texture == null: continue
			
			match heart_textures[jndex].texture:
				health_resource.full_heart_texture: # Full to half
					await CustomTween.jump_up(heart_textures[jndex], pop_up_position, duration)
					heart_textures[jndex].texture = health_resource.half_heart_texture
					break
				health_resource.half_heart_texture: # Half to null
					await CustomTween.jump_up(heart_textures[jndex], pop_up_position, duration)
					heart_textures[jndex].texture = null
					break

func load_health(_current_health: int, _max_health: int = 100):
	current_health = _current_health
	max_health = _max_health
