extends Node2D

class_name AnimationControl

@export var animation_player : AnimationPlayer
@export var animation_tree : AnimationTree
var character : MainCharacter
var direction : Vector2
var tool : String = ""

func _ready() -> void:
	if get_parent().is_in_group("Entity"):
		character = get_parent()
	
#	Initialize state
	animation_tree["parameters/conditions/is_idling"] = true

func _process(_delta: float) -> void:
	if not character: return
	direction = character.facing_direction
	
#	idle condition
	if not character.is_tooling() and character.character_controller.is_walking:
		animation_tree["parameters/conditions/is_walking"] = true
		animation_tree["parameters/conditions/is_idling"] = false
		animation_tree["parameters/conditions/is_tooling"] = false
		
#	walking condition
	elif not character.is_tooling() and not character.character_controller.is_walking:
		animation_tree["parameters/conditions/is_walking"] = false
		animation_tree["parameters/conditions/is_idling"] = true
		animation_tree["parameters/conditions/is_tooling"] = false
	
	elif character.is_tooling():
		animation_tree["parameters/conditions/is_walking"] = false
		animation_tree["parameters/conditions/is_idling"] = false
		animation_tree["parameters/conditions/is_tooling"] = true
		
		var is_axe : bool = true
		animation_tree["parameters/tool/conditions/is_axe"] = is_axe
		animation_tree["parameters/tool/conditions/is_food"] = !is_axe
		
	if direction != Vector2.ZERO: 
		var mouse_pos = character.get_local_mouse_position()
		animation_tree["parameters/idle/blend_position"] = direction if !character.is_look_at_mouse else mouse_pos
		animation_tree["parameters/walking/blend_position"] = direction
		# Inside tool state machine
		animation_tree["parameters/tool/axe/blend_position"] = direction
		animation_tree["parameters/tool/food/blend_position"] = direction

func look_at_mouse(pos: Vector2):
	animation_tree["parameters/idle/blend_position"] = pos
