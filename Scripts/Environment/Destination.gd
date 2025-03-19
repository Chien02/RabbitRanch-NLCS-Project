extends Area2D

class_name Destination

signal Lose

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Animal"):
		print("You loss")
		Lose.emit()
