extends Node2D

class_name AnimationControl

@export var animation_player : AnimationPlayer
@export var animation_tree : AnimationTree
var character : MainCharacter
var direction : Vector2

func _ready() -> void:
	if get_parent().is_in_group("Entity"):
		character = get_parent()
	
#	Initialize state
	animation_tree["parameters/conditions/is_idling"] = true

func _process(_delta: float) -> void:
	if not character: return
	direction = character.character_controller.direction
	
#	idle condition
	if character.character_controller.is_walking:
		animation_tree["parameters/conditions/is_walking"] = true
		animation_tree["parameters/conditions/is_idling"] = false
		
		
#	walking condition
	elif not character.character_controller.is_walking:
		animation_tree["parameters/conditions/is_walking"] = false
		animation_tree["parameters/conditions/is_idling"] = true
		
		
	if direction != Vector2.ZERO: 
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/walking/blend_position"] = direction
		
