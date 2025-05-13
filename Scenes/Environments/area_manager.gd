extends Node2D

class_name AreaManager

var areas : Array[Area2D] = []

signal body_entered
signal body_exited

func _on_area_2d_body_entered(body: Node2D) -> void:
	body_entered.emit(body, $Area2D)

func _on_area_2d_body_exited(body: Node2D) -> void:
	body_exited.emit(body, $Area2D)

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	body_entered.emit(body, $Area2D2)

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	body_exited.emit(body, $Area2D2)

func _on_area_2d_3_body_entered(body: Node2D) -> void:
	body_entered.emit(body, $Area2D3)

func _on_area_2d_3_body_exited(body: Node2D) -> void:
	body_exited.emit(body, $Area2D3)

func _on_area_2d_4_body_entered(body: Node2D) -> void:
	body_entered.emit(body, $Area2D4)

func _on_area_2d_4_body_exited(body: Node2D) -> void:
	body_exited.emit(body, $Area2D4)

func _on_area_2d_5_body_entered(body: Node2D) -> void:
	body_entered.emit(body, $Area2D3)

func _on_area_2d_5_body_exited(body: Node2D) -> void:
	body_exited.emit(body, $Area2D3)
