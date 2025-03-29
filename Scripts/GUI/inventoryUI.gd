extends Control

class_name InventoryUI

@export var item_vbox_container : VBoxContainer
@export var tool_vbox_container : VBoxContainer

@onready var inventory : Inventory = get_tree().get_first_node_in_group("Inventory")
@export var main_slot_1 : SlotUI
@export var main_slot_2 : SlotUI

func _ready() -> void:
	if inventory:
		inventory.AddItem.connect(set_slot_texture)

func _process(_delta: float) -> void:
	if inventory.slots.is_empty(): return
	
func _on_item_slot_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.is_pressed(): return
		appear_list(item_vbox_container)
		tool_vbox_container.visible = false

func _on_tool_slot_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.is_pressed(): return
		appear_list(tool_vbox_container)
		item_vbox_container.visible = false

func appear_list(container: VBoxContainer):
	container.visible = !container.visible

func set_slot_texture(item: Item):
	var duration : float = 1.0
	var slot : SlotUI
	if main_slot_1.texture_rect.texture == null:
		slot = main_slot_1
	elif main_slot_2.texture_rect.texture == null:
		slot = main_slot_2
	
	slot.visible = true
	slot.texture_rect.texture = item.resource.texture
	await CustomTween.pop_up(slot.slot_panel, Vector2(1, 1), duration)
	slot.input_panel.visible = true
