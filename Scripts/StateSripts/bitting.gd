extends BaseState

class_name Bitting

@export var label : Label
@export var animation_duration : float = 0.67

func enter_state(_value: Node2D = null):
	if !character.turnbase_actor.is_active: return
	print("From Wolf Bitting: Entered Bitting State")
	
	character.Bited.emit()
	
	# Mỗi lần cắn đều được cộng 1, hàm bên dưới hoạt động tương tự như charge state
	if _value != null and _value is Character:
		print("From Wolf Bitting: Damaged to: ", _value.name)
		_value.health.damage(15)
		# Xong release character.target để tránh gặp vòng lặp
		character.target = null
	
	character.charge_point += 1
	if character.charge_point >= character.max_charge_point:
		character.charge_point = character.max_charge_point
	
	label.text = "+1"
	var duration : float = 0.5
	var float_up_distance : Vector2 = Vector2(0, -20)
	CustomTween.fade_up(label, float_up_distance, duration)
	await character.get_tree().create_timer(animation_duration).timeout
	switch_to_idle()

func exit_state():
	print("From Wolf Bitting: ", character.name, " exit bitting state")

func switch_to_idle():
	character.turnbase_actor.emit_endturn("I finished bitting")
	SwitchState.emit(self, "idle")
