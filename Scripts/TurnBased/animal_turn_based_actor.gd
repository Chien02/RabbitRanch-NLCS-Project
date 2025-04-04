extends TurnBaseActor

class_name AnimalTurnBaseActor

var character : Animal

func init(_character):
	character = _character

func active():
	super()
	character.is_finished_special = false

func emit_endturn():
	active()
	print("---------------[End turn: ", character.name, "]---------------")
	EndTurn.emit()
