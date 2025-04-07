extends Node2D

class_name WolfAnimationControl

@export var animation_player : AnimationPlayer
@export var animation_tree : AnimationTree
@export var character : Character

var is_specialing : bool = false
var is_charging : bool = false

func _ready() -> void:
	if !character: return
	character.health.Died.connect(_on_health_die)
	character.health.Hurted.connect(_on_health_hurt)

func _process(_delta: float) -> void:
	if is_specialing:
		animation_tree["parameters/conditions/is_biting"] = !is_charging
		animation_tree["parameters/conditions/is_smiling"] = is_charging
		animation_tree["parameters/conditions/is_idling"] = !is_specialing
		animation_tree["parameters/conditions/is_hurting"] = !is_specialing
		animation_tree["parameters/conditions/is_walking"] = !is_specialing
		return
	
	if character.character_controller.is_walking:
		is_specialing = false
		animation_tree["parameters/conditions/is_biting"] = is_specialing
		animation_tree["parameters/conditions/is_smiling"] = is_specialing
		animation_tree["parameters/conditions/is_idling"] = is_specialing
		animation_tree["parameters/conditions/is_hurting"] = is_specialing
		animation_tree["parameters/conditions/is_walking"] = !is_specialing
	else:
		is_specialing = false
		animation_tree["parameters/conditions/is_biting"] = is_specialing
		animation_tree["parameters/conditions/is_smiling"] = is_specialing
		animation_tree["parameters/conditions/is_idling"] = !is_specialing
		animation_tree["parameters/conditions/is_hurting"] = is_specialing
		animation_tree["parameters/conditions/is_walking"] = is_specialing
	
func set_is_specialing(value: bool, _is_charging: bool = false):
	is_specialing = value
	is_charging = _is_charging if _is_charging != false else false

func _on_health_hurt():
	animation_tree["parameters/conditions/is_hurting"] = true
	animation_tree["parameters/conditions/is_idling"] = true
	animation_tree["parameters/conditions/is_biting"] = false
	animation_tree["parameters/conditions/is_smiling"] = false
	animation_tree["parameters/conditions/is_walking"] = false
	
func _on_health_die():
	animation_tree["parameters/conditions/is_hurting"] = true
	animation_tree["parameters/conditions/is_idling"] = true
	animation_tree["parameters/conditions/is_biting"] = false
	animation_tree["parameters/conditions/is_smiling"] = false
	animation_tree["parameters/conditions/is_walking"] = false
