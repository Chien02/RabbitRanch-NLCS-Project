extends Node2D

class_name TurnBasedManager

var actor = []
var current_actor

func _ready() -> void:
	get_actor()

func get_actor():
	for child in get_children():
		if child.is_in_group("Entity"):
			actor.append(child)
			child.turnbase_actor.EndTurn.connect(switch_actor)
	current_actor = actor.pop_front()
	active_actor()

func active_actor():
	if !current_actor: return
	current_actor.turnbase_actor.active()
	print("active actor", current_actor.name)

func switch_actor():
	actor.push_back(current_actor)
	current_actor = actor.pop_front()
	active_actor()
