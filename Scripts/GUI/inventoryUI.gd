extends Control

class_name InventoryUI


@export var item_vbox_container : VBoxContainer
@export var tool_vbox_container : VBoxContainer

@onready var inventory : Inventory = get_tree().get_first_node_in_group("Inventory")
@export var main_slot_1 : TextureRect
@export var main_slot_2 : TextureRect

func _ready() -> void:
	if inventory:
		inventory.AddItem.connect(set_slot_texture)

func _process(delta: float) -> void:
	if inventory.slots.is_empty(): return
	

func _on_item_slot_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.is_pressed(): return
		appear_list(item_vbox_container)

func _on_tool_slot_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.is_pressed(): return
		appear_list(tool_vbox_container)

func appear_list(container: VBoxContainer):
	container.visible = !container.visible

func set_slot_texture(item: Item):
	if main_slot_1.texture == null:
		main_slot_1.texture = item.resource.texture
	elif main_slot_2.texture == null:
		main_slot_2.texture = item.resource.texture
