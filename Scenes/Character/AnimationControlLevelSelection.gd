extends Node2D

class_name AnimationControlLevelSelection

@export var character : CharacterSelectLevel
@export var animation_tree: AnimationTree

func _process(_delta: float) -> void:
	var facing_direction : Vector2 = character.facing_direction
	var is_walking : bool = character.character_controller.is_walking
	
	# Set conditions
	animation_tree["parameters/conditions/is_idling"] = !is_walking
	animation_tree["parameters/conditions/is_walking"] = is_walking
	
	# Set directions
	animation_tree["parameters/idle/blend_position"] = facing_direction
	animation_tree["parameters/walking/blend_position"] = facing_direction
	
