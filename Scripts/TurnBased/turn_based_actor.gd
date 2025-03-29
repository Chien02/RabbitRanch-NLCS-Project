extends Node2D

class_name TurnBaseActor

var is_active : bool = false

signal EndTurn

func active():
	is_active = not is_active

func emit_endturn():
	active()
	print("---------------[End turn: MainCaracter]---------------")
	EndTurn.emit()
