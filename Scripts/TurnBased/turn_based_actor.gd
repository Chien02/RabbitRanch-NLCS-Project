extends Node2D

class_name TurnBaseActor

var is_active : bool = false
var character : Character

signal EnterTurn
signal EndTurn

func _init(_character: Character = null) -> void:
	character = _character

func active():
	is_active = true
	EnterTurn.emit(1)
	if !character: return
	print("---------------[Enter turn: ", character.name,"]---------------")

func emit_endturn(_value: String = ""):
	is_active = false
	print("From ", character.name, ": Reason why I end turn is " + _value)
	print("---------------[End turn: ", character.name,"]---------------")
	EndTurn.emit(character)
