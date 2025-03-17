extends Node2D

class_name AnimalAnimationControl

@export var animation_tree : AnimationTree
var direction : Vector2
var character

func _ready() -> void:
	if get_parent().is_in_group("Entity"):
		character = get_parent()
		print(character.name)
	
	if animation_tree:
		change_idle()

func change_anim(state: String):
	match state:
		"idle": change_idle()
		"walk": change_walk()


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

func change_idle():
	animation_tree["parameters/conditions/is_idling"] = true
	animation_tree["parameters/conditions/is_walking"] = false

func change_walk():
	animation_tree["parameters/conditions/is_idling"] = false
	animation_tree["parameters/conditions/is_walking"] = true
