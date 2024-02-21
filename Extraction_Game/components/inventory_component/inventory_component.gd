class_name InventoryComponent
extends Node

@export var parent: Character

@export var inventory: Array[InventoryItem]

func get_inventory() -> Array[InventoryItem]:
	return inventory
	
	
func _add_to_inventory(item: InventoryItem):
	inventory.append(item)
	
	
func _remove_from_inventory(item: InventoryItem):
	var item_index = inventory.find(item)
	inventory.remove_at(item_index)
	

