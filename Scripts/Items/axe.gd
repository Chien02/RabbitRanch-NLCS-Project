extends Item

class_name Axe

var signal_flag : bool = false

func _ready() -> void:
	is_activating = false
	if character:
		character.area.area_entered.connect(_on_character_area_entered)
		character.area.body_entered.connect(_on_character_body_entered)
 
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter:
		print("From Item: collide with Main Character")
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
	# Check connection once again
	if !character.area.area_entered.is_connected(_on_character_area_entered):
		character.area.area_entered.connect(_on_character_area_entered)
	if !character.area.body_entered.is_connected(_on_character_body_entered):
		character.area.body_entered.connect(_on_character_body_entered)
	
	# Send signal to AnimationControl
	#character.inventory.UsingItem.emit(resource.name.to_lower())
	character.area.get_child(0).disabled = false
	
	# This signal use for knowing that received or not the signal from character
	if signal_flag == false:
		await character.get_tree().create_timer(0.5).timeout
		finish_active()


func finish_active():
	super()
	character.area.get_child(0).disabled = true
	is_activating = false
	character.tooling = false


func _on_character_area_entered(area: Area2D):
	print("From Axe: Connected with Character.area area_entered")
	if area is Obstacle and area.is_breakable():
		signal_flag = true
		var destroy_duration : float = 0.5
		area.destroy(destroy_duration, character)
		await character.get_tree().create_timer(0.5).timeout
		finish_active()


func _on_character_body_entered(body: Node2D):
	if !is_activating: return
	if body is Wolf and body.health != null:
		signal_flag = true
		body.health.damage(15)
		await character.get_tree().create_timer(0.5).timeout
		finish_active()
