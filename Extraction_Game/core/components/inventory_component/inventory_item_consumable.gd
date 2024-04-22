class_name InventoryItemConsumable
extends InventoryItem

func to_dictionary() -> Dictionary:
	var base_data: Dictionary = super.to_dictionary()
	return base_data

func from_dictionary(data: Dictionary) -> void:
	super.from_dictionary(data)
