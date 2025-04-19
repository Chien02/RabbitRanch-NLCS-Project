extends CharacterBody2D

class_name Character

@export var health : Health
@export var area : Area2D
@export var state_machine : StateMachine
@export var audio : CharacterSoundFX

@export_category("Resources")
@export var resource : CharacterResource

signal OutOfStunned
signal Disappear

var is_stun : bool = false
var turn_counter : int = 0
var max_stunned_turn : int = 0
var turnbase_actor : TurnBaseActor

func _ready() -> void:
	if health:
		health.Died.connect(_on_health_die)
		health.Hurted.connect(_on_health_hurt)


func stunned(stun: bool, num_of_turn: int):
	is_stun = stun
	max_stunned_turn = num_of_turn
	turn_counter = 0

func _on_enter_turn(num: int):
	if !is_stun: return
	print("From ", name, ": Still be stunned and calculate turn_counter")
	turn_counter += num
	print("From ", name,": counting turn_counter to ", turn_counter)
	
	if turn_counter == max_stunned_turn:
		turn_counter = 0
		turnbase_actor.EnterTurn.disconnect(_on_enter_turn)
		print("From ", name,": Out of stunned")
		is_stun = false
		OutOfStunned.emit()

func set_character_visible(_bool: bool):
	visible = _bool

func _on_health_die():
	print("From ", name, ": Dieeeeeeee")
	if !audio: return
	audio.play_sound(CharacterSoundFX.Sound.HIT)
	Disappear.emit(self)

func _on_health_hurt():
	if !audio: return
	audio.play_sound(CharacterSoundFX.Sound.HIT)
