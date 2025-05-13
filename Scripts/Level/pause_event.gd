extends LevelEvent

class_name PauseEvent

@export var pause_button : Button

func _ready() -> void:
	if level_manager != null:
		level_manager.Paused.connect(pause)
	set_process(false)

func _on_setting_pressed() -> void:
	audio.play_sound(UISoundFX.Sound.SELECT)
	gui.setting.visible = !gui.setting.visible

func _on_visibility_changed() -> void:
	set_process(visible)
	if pause_button:
		pause_button.visible = !visible

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		_on_continue_pressed()

func _on_pause_button_pressed() -> void:
	audio.play_sound(UISoundFX.Sound.SELECT)
	pause()
