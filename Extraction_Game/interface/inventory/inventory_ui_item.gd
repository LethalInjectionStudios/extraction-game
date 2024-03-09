class_name InventoryUIButton
extends Button

signal item_selected(item: InventoryItem)

@export var quantity: Label
@export var item_icon: Sprite2D

var item: InventoryItem

func _ready() -> void:
	connect("pressed", _on_button_pressed)
	connect("mouse_entered", _on_mouse_entered)


func _on_button_pressed() -> void:
	item_selected.emit(item)

func _on_mouse_entered() -> void:
	pass #print(item.item_name)
