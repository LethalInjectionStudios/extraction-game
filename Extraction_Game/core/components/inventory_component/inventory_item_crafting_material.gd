class_name InventoryItemCraftingMaterial
extends InventoryItem

var quantity: int

func to_dictionary() -> Dictionary:
	var base_data: Dictionary = super.to_dictionary()
	base_data["quantity"] = quantity
	return base_data

func from_dictionary(data: Dictionary) -> void:
	super.from_dictionary(data)
	quantity = data["quantity"]
