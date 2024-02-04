class_name InventoryUIButton
extends Button

signal item_selected(item: InventoryItem)

var item: InventoryItem

func _ready():
	connect("pressed", _on_button_pressed)


func _on_button_pressed():
	item_selected.emit(item)