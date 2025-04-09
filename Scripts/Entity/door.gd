extends Destination

class_name Door

@export var animation_player : AnimationPlayer
var last_body : Character

func _on_body_entered(body: Node2D) -> void:
	# Play animation first
	animation_player.play("open")
	last_body = body

func on_animal_entered():
	if last_body == null: return
	# Then check for the counting animal events
	var animal_manager : AnimalManager = get_tree().get_first_node_in_group("LevelManager").animals_manager
	if last_body is Animal and last_body is not Wolf:
		print("From Door: Animal Entered")
		animal_manager.caught_animal(last_body, AnimalManager.Catcher.DESTINATION)
