extends Node2D

class_name StateMachine

@export var initial_state : BaseState
var character
var states : Dictionary = {}
var current_state : BaseState

func _ready() -> void:
	if get_children().is_empty(): return
	
	if get_parent().is_in_group("Entity"):
		character = get_parent()
	
	for child in get_children():
		if child is BaseState:
			child.character = character
			states[child.name.to_lower()] = child
			child.SwitchState.connect(_on_switch_state)
	
	if initial_state:
		current_state = initial_state

func _process(_delta: float) -> void:
	if not character.turnbase_actor.is_active: return
	if current_state:
		current_state.update_state()

func _physics_process(_delta: float) -> void:
	if not character.turnbase_actor.is_active: return
	if current_state:
		current_state.physics_update()

func _on_switch_state(state: BaseState, new_state_name: String):
	if state != current_state: return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("From State Machine: Cannot get new state ", new_state_name.to_lower())
		return
	
	if current_state:
		current_state.exit_state()
	
	new_state.enter_state()
	current_state = new_state
