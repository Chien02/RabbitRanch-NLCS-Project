extends BaseState

class_name Tooling

var tooling : bool = false

func enter_state():
	print("From Tooling: Enter tooling state")

func exit_state():
	print("From Tooling: Exit tooling state")

func update_state():
	check_for_switch()

func check_for_switch():
	if !character.is_tooling():
		SwitchState.emit(self, "idle")
