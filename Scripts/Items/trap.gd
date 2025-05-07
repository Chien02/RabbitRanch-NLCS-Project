extends ThrowableItem

class_name Trap

@export var animation_player : AnimationPlayer
@export var area : Area2D
@export var max_stunned_turn : int = 3

func _ready() -> void:
	is_selecting = false
	if !animation_player: return
	if !is_selecting and character:
		animation_player.play("trap_open")
		is_activating = true
	else: animation_player.play("trap_item")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter and !is_activating:
		print("From Trap: collide with Main Character")
		# play audio
		if audio:
			audio.play_sound(CharacterSoundFX.Sound.COLLECT)
		
		# Add this item to player's inventory by give it new instance, then just disappear
		var new_item : Trap = load(resource.link).instantiate()
		new_item.init(grid, body, resource)
		body.inventory.add_item(new_item)
		disappear()
		
		# But player is using it, then the its sprite would be change
		# And the following is change trap's state to close (catch character)
	elif is_activating:
		print("From Trap: collide with ", body.name)
		animation_player.play("trap_close")
		hold(body)


func hold(body: Node2D):
	if !body is Character: return
	# Disable Trap collider
	area.get_child(0).set_deferred("disabled", true)
	# Call the stun method from the Character's script
	# Then connect with the OutOfStunned signal to know when the trap would disappear
	body.stunned(true, max_stunned_turn)
	body.OutOfStunned.connect(disappear)
	print("From Trap: Trapped ", body.name)


func active():
	super()
