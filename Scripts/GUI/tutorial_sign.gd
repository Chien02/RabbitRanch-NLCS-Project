extends Control

# Tutorial Sign UI
class_name Tutorial

@export var tutorial_name : String
@export var audio : AudioStreamPlayer2D

var displayUI : DisplayUI

func _ready() -> void:
	GlobalProperties.tutorial = self
	displayUI = get_parent()
	if displayUI is not DisplayUI:
		print("From Tutorial: Cannot get displayUI")
	set_visible(false)

func _on_button_pressed() -> void:
	audio.play()
	await get_tree().create_timer(0.25).timeout
	disappear()

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
