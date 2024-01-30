class_name InventoryComponent
extends Node

@export var parent: Character

@export var inventory: Inventory

func get_inventory() -> Inventory:
	return inventory
	
	
func _add_to_inventory(item: InventoryItem):
	inventory.inventory.append(item)
	
	
# func _remove_from_inventory(item: InventoryItem):
# 	pass
	

