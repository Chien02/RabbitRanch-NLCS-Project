extends Node2D

class_name TurnBaseActor

var is_active : bool = false

signal EndTurn

func active():
	is_active = true

func emit_endturn():
	active()
	EndTurn.emit()
