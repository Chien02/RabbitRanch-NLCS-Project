extends Node2D

class_name WolfAnimationControl

@export var animation_player : AnimationPlayer
@export var animation_tree : AnimationTree
@export var character : Character

var is_specialing : bool = false
var is_charging : bool = false
var is_bitting : bool = false
var is_hurting: bool = false

func _ready() -> void:
	if !character: return
	character.health.Died.connect(_on_health_hurt)
	character.health.Hurted.connect(_on_health_hurt)
	character.Charged.connect(_on_wolf_charged)
	character.Bited.connect(_on_wolf_bited)

func _process(_delta: float) -> void:
	var is_walking : bool = character.character_controller.is_walking
	animation_tree["parameters/conditions/is_hurting"] = is_hurting
	animation_tree["parameters/conditions/is_biting"] = is_bitting
	animation_tree["parameters/conditions/is_smiling"] = is_charging
	animation_tree["parameters/conditions/is_idling"] = !is_walking and !is_bitting and !is_charging and !is_hurting
	animation_tree["parameters/conditions/is_walking"] = is_walking


func set_is_specialing(value: bool, _is_charging: bool = false):
	is_specialing = value
	is_charging = _is_charging if _is_charging != false else false


func _on_health_hurt():
	print("From WolfAnimation: Received hurt signal")
	is_hurting = true
	await get_tree().create_timer(0.75).timeout
	is_hurting = false


func _on_wolf_bited():
	print("From WolfAnimation: Received bited signal")
	is_bitting = true
	await get_tree().create_timer(0.75).timeout
	is_bitting = false


func _on_wolf_charged():
	print("From WolfAnimation: Received charged signal")
	is_charging = true
	await get_tree().create_timer(0.75).timeout
	is_charging = false
