extends TurnBaseActor

class_name AnimalTurnBaseActor

var character : Animal

func _new(_character):
	character = _character

func active():
	is_active = !is_active
	character.is_finished_special = false

func emit_endturn():
	active()
	print("---------------[End turn: ", character.name, "]---------------")
	EndTurn.emit()
