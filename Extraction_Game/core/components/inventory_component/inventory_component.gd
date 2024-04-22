class_name InventoryComponent
extends Node

@export var parent: Character
@export var inventory: Array[InventoryItem]

var weight: float = 0
var max_weight: float = 60

func get_inventory() -> Array[InventoryItem]:
	return inventory
	
	
func _add_to_inventory(new_item: InventoryItem) -> void:

	var item_data: Resource = load(new_item.item_path)

	if new_item is InventoryItemAmmo or new_item is InventoryItemCraftingMaterial:
		var item_found: bool = false
		for item: InventoryItem in inventory:
			if item.item_name == new_item.item_name && !item_found:
				item_found = true
				item.quantity += new_item.quantity
				weight += new_item.quantity * item_data.weight
		if !item_found:
			inventory.append(new_item)
			weight += new_item.quantity * item_data.weight

	else:
		inventory.append(new_item)
		weight += item_data.weight

	
func _remove_from_inventory(item: InventoryItem) -> void:
	var item_index: int = inventory.find(item)
	inventory.remove_at(item_index)
	

func remove_ammo(type: Ammunition, amount: int) -> int:
	for item: InventoryItem in inventory:
		if item is InventoryItemAmmo:
			if item.item_name == type.name: #Fix this later
				if item.quantity >= amount:
					item.quantity -= amount
					if item.quantity <= 0:
						_remove_from_inventory(item)

					return amount

				if item.quantity < amount:
					amount = item.quantity
					_remove_from_inventory(item)
					return amount

	return 0
