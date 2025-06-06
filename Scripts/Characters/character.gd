extends CharacterBody2D

class_name Character

@export var health : Health
@export var area : Area2D
@export var state_machine : StateMachine
@export var audio : CharacterSoundFX
@export var particle : CPUParticles2D
@export var grid : Grid

@export_category("Resources")
@export var resource : CharacterResource

var character_controller : CharacterController
var turnbase_actor : TurnBaseActor

signal OutOfStunned
signal Disappear

var is_stun : bool = false
var turn_counter : int = 0
var max_stunned_turn : int = 0
var facing_direction : Vector2 = Vector2(0.0, 1.0)
var local_position : Vector2i = Vector2i.ZERO

func _ready() -> void:
	if health:
		health.Died.connect(_on_health_die)
		health.Hurted.connect(_on_health_hurt)
	if grid:
		local_position = grid.local_to_map(global_position)


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
	if !audio: return
	audio.play_sound(CharacterSoundFX.Sound.HIT)
	play_particle()
	await get_tree().create_timer(0.15).timeout
	Disappear.emit(self)

func _on_health_hurt():
	if !audio: return
	audio.play_sound(CharacterSoundFX.Sound.HIT)
	play_particle()


func play_particle():
	if !particle: return
	if !particle.visible:
		particle.visible = true
	# Lấy hướng nhìn của nhân vật để chuyển hướng particle
	particle.direction.x = 10.0 if facing_direction.x <= 0 else -10.0
	#particle.direction
	particle.emitting = true

func update_local_position():
	if !grid:
		grid = get_tree().get_first_node_in_group("Grid")
	local_position = grid.local_to_map(global_position)
	print("From ", name, ": position is ", global_position, " and local is: ", local_position)
