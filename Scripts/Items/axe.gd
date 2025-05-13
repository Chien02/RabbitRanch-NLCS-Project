extends Item

class_name Axe

var signal_flag : bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter:
		print("From Item: collide with Main Character")
		# Play audio when player collected it
		if audio:
			audio.play_sound(CharacterSoundFX.Sound.COLLECT)
		
		var new_axe = Axe.new()
		new_axe.init(grid, body, resource)
		body.inventory.add_item(new_axe)
		disappear()
		return

func active():
	if is_activating: return
	signal_flag = false
	is_activating = true
	character.tooling = true
	
	# Chechk that axe_hitbox is existed or not
	character.hitbox_collider.position = character.facing_direction * character.grid.tile_size
	character.hitbox_collider.disabled = false
	
	# Check connection once again
	if !character.hitbox.area_entered.is_connected(_on_character_area_entered):
		character.hitbox.area_entered.connect(_on_character_area_entered)
	if !character.hitbox.body_entered.is_connected(_on_character_body_entered):
		character.hitbox.body_entered.connect(_on_character_body_entered)
	
	# Send signal to AnimationControl
	# character.inventory.UsingItem.emit(resource.name.to_lower())
	
	# This signal use for knowing that received or not the signal from character
	if signal_flag == false:
		await character.get_tree().create_timer(0.35).timeout
		finish_active()


func finish_active():
	super()
	character.hitbox_collider.disabled = true
	is_activating = false
	character.tooling = false


func _on_character_area_entered(area: Area2D):
	if !is_activating: return
	print("From Axe: Connected with axe_hitbox area_entered")
	if area is Obstacle and area.is_breakable():
		signal_flag = true
		var destroy_duration : float = 0.35
		# play audio
		if character.audio:
			var random : int = randi_range(0, 1)
			match random:
				0: character.audio.play_sound(CharacterSoundFX.Sound.CHOP1)
				1: character.audio.play_sound(CharacterSoundFX.Sound.CHOP2)
		
		area.destroy(destroy_duration, character)
		await character.get_tree().create_timer(0.35).timeout
		finish_active()
	if area != null:
		if area is Obstacle and !area.is_breakable():
			if character.audio:
				character.audio.play_sound(CharacterSoundFX.Sound.MINING)
			await character.get_tree().create_timer(0.35).timeout
			finish_active()


func _on_character_body_entered(body: Node2D):
	if !is_activating: return
	if body is Wolf and body.health != null:
		signal_flag = true
		body.health.damage(15)
		await character.get_tree().create_timer(0.35).timeout
		finish_active()
