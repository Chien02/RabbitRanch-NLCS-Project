extends Area2D

class_name Destination

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Animal"):
		print("You loss")
