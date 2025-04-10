extends Node2D

class_name BaseState

var character : Character

signal SwitchState

func enter_state(_value: Node2D = null):
	pass

func exit_state():
	pass

func update_state():
	pass

func physics_update():
	pass
