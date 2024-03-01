class_name InventoryComponent
extends Node

@export var parent: Character

@export var inventory: Array[InventoryItem]

func get_inventory() -> Array[InventoryItem]:
	return inventory
	
	
func _add_to_inventory(item: InventoryItem) -> void:
	inventory.append(item)
	
	
func _remove_from_inventory(item: InventoryItem) -> void:
	var item_index: int = inventory.find(item)
	inventory.remove_at(item_index)
	

