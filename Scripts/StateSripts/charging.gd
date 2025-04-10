extends BaseState

class_name Charging

@export var animation_duration : float = 0.67
@export var label : Label

func enter_state(_value: Node2D = null):
	if !character.turnbase_actor.is_active: return
	print("From Wolf Charging: Entered")
	character.Charged.emit()
	
	# Tăng điểm tích tụ, không được lớn hơn max, đồng thời hiển thị hiệu ứng cộng 1 điểm tụ
	character.charge_point += 1
	if character.charge_point >= character.max_charge_point:
		character.charge_point = character.max_charge_point
	
	label.text = "+1"
	var duration : float = 0.67
	var float_up_distance : Vector2 = Vector2(0, -20)
	CustomTween.fade_up(label, float_up_distance, duration)
	
	print("From Wolf Charging: Charge point: ", character.charge_point)
	# Chờ animation hoàn thành
	await get_tree().create_timer(animation_duration).timeout
	switch_to_idle()

func switch_to_idle():
	print("From Wolf Charging: Finished charging, switch to idle state")
	character.area.get_child(0).disabled = true
	SwitchState.emit(self, "idle")
	character.turnbase_actor.emit_endturn("I finished charging")

func exit_state():
	print("From Wolf Charging: Exited")

func update_state():
	pass
