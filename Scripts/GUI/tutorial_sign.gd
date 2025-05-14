extends Control

# Tutorial Sign UI
class_name Tutorial

@export var tutorial_name : String
@export var audio : UISoundFX
@export var animation_player : AnimationPlayer

var displayUI : DisplayUI

func _ready() -> void:
	GlobalProperties.tutorial = self
	displayUI = get_parent()
	if displayUI is not DisplayUI:
		print("From Tutorial: Cannot get displayUI")
	set_visible(false)
	set_process(false)


func _on_button_pressed() -> void:
	audio.play_sound(UISoundFX.Sound.CONFIRM)
	await get_tree().create_timer(0.25).timeout
	disappear()

func _process(_delta: float) -> void:
	if !visible: return
	if Input.is_action_just_pressed("accept"):
		_on_button_pressed()

func appear() -> void:
	# Check for tutorial flag in Global, make sure don't repeat the tutorial
	if GlobalProperties.check_tutorial(tutorial_name):
		# Check visible if it true then turn off it
		visible = false
		return
	displayUI.blur(true, 0.5) # VFX when pause the game
	get_tree().paused = !get_tree().paused
	set_visible(true)


func disappear():
	displayUI.blur(false)
	get_tree().paused = !get_tree().paused
	GlobalProperties.completed_tutorial(tutorial_name)
	set_visible(false)

# Use this in animation_player as call method key
func play_soundfx_when_appear():
	$PlayWhenAppear.play()

func _on_visibility_changed() -> void:
	if visible:
		animation_player.play("fade_in")
		set_process(true)
	elif !visible:
		animation_player.play("fade_out")
