extends TurnBaseActor

class_name AnimalTurnBaseActor

var character : Animal

func _new(_character):
	character = _character

func active():
	print("Enter turn Animal")
	is_active = !is_active
	character.is_finished_special = false

func emit_endturn():
	active()
	EndTurn.emit()
