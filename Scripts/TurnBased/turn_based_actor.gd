extends Node2D

class_name TurnBaseActor

var is_active : bool = false

signal EnterTurn
signal EndTurn

func active():
	is_active = not is_active
	if is_active:
		EnterTurn.emit(1)
		print("From ", name, ": emit end turn")

func emit_endturn():
	active()
	print("---------------[End turn: MainCaracter]---------------")
	EndTurn.emit()
