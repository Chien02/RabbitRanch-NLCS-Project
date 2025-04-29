extends Node2D

class_name Chest

@export var items_path_in_chest : Array[String] = [
	"res://Scenes/Items/axe.tscn",
	"res://Scenes/Items/trap.tscn"
]

@onready var collider : CollisionShape2D = get_child(0)
@onready var animation_player : AnimationPlayer = get_node("AnimationControll/AnimationPlayer")
@onready var audio : AudioStreamPlayer2D = get_child(2)
@onready var control : Control = get_child(3)

var start_position : Vector2
var temp_character : MainCharacter = null
var openable : bool = false

signal CollectedItem

func _ready() -> void:
	animation_player.play("idle")
	if !control:
		control = get_child(3)
	start_position = control.position

func _process(_delta: float) -> void:
	if !openable: return
	if Input.is_action_just_pressed("accept"):
		open_chest(temp_character)

func openable_chest(value: bool, character: MainCharacter):
	openable = value
	control.visible = value
	
	if value == false:
		temp_character = null
		return
	
	temp_character = character
	CustomTween.loop_up_down(control, start_position, -5.0, 1)

func open_chest(body: MainCharacter) -> void:
	if body is not Character: return
	print("From Chest: Player press accept open chest")
	
	# Turn off collider and guide
	control.visible = false
	CustomTween.kill_tween()
	collider.set_deferred("disabled", true)
	# Play effect
	animation_player.play("open")
	audio.play()
	# Actual add item to inventory
	_get_item_in_chest(body)

func _get_item_in_chest(body: MainCharacter):
	var item_path : String = items_path_in_chest.pick_random()
	var item : Item = load(item_path).instantiate()
	# Connect with CollectEventUI
	CollectedItem.emit(item)
	
	# Add item to player's inventory
	if body is MainCharacter:
		body.inventory.add_item(item)
		openable = false
	
	await get_tree().create_timer(1.5).timeout
	animation_player.play("close")
