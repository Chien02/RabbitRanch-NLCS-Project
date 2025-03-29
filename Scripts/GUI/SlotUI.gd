extends Panel

class_name SlotUI

const SELECTING_FRAME_COLOR : Color = Color(0.986, 0.767, 0.0)
const UNSELECTING_FRAME_COLOR : Color = Color(0.8, 0.8, 0.8)
const SCALE_DURATION : float = 0.5
@onready var set_main_item_btn : Button = get_child(0)

func frame_visible(turn_on: bool):
	match turn_on:
		true: turn_on()
		false: turn_off()

func turn_on():
	self["theme_override_styles/panel"].border_color = SELECTING_FRAME_COLOR
	set_main_item_btn.visible = true
	scale = Vector2(1.25, 1.25)
	#CustomTween.scale_to(self, Vector2(1.5, 1.5), SCALE_DURATION)

func turn_off():
	self["theme_override_styles/panel"].border_color = UNSELECTING_FRAME_COLOR
	set_main_item_btn.visible = false
	scale = Vector2(1, 1)
	#CustomTween.scale_to(self, Vector2(1, 1), SCALE_DURATION)
