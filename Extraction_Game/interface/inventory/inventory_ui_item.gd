class_name InventoryUIButton
extends Button

signal item_selected(item: InventoryItem)

var item: InventoryItem

func _ready() -> void:
	connect("pressed", _on_button_pressed)


func _on_button_pressed() -> void:
	item_selected.emit(item)