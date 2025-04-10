extends Node2D

class_name TurnBasedManager

var actor : Array[Character] = []
var current_actor

func _ready() -> void:
	get_actor()

func get_actor():
	for child in get_children():
		if child.is_in_group("Entity"):
			actor.append(child)
			child.turnbase_actor.EndTurn.connect(switch_actor)
	
	if actor.is_empty():
		print("From turnBased management: Cannot get the actors")
		return
	else:
		current_actor = actor.pop_front()
		active_actor()

func switch_actor(_current_actor: Character):
	if current_actor != _current_actor:
		print("From TurnbasedManager: current_actor: ", current_actor, " is not like this actor: ", _current_actor)
		return
	print("From TurnbaseManager: Now switch actor")
	if current_actor != null:
		print("From TurnbaseManager: old_actor: ", current_actor.name)
		actor.push_back(current_actor)
		current_actor = actor.pop_front()
	if current_actor == null:
		current_actor = actor.pop_front()
		print("From TurnbaseManager: new_actor: ", current_actor.name)
	
	active_actor()
	
func active_actor():
	if !current_actor: return
	current_actor.turnbase_actor.active()
