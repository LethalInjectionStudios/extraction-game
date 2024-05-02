class_name InventoryItemArmor
extends InventoryItem

var durability: float
var equipped: bool
var status: Globals.Armor_Status

func to_dictionary() -> Dictionary:
	var base_data: Dictionary = super.to_dictionary()
	base_data["durability"] = durability
	base_data["equipped"] = equipped
	base_data["armor_status"] = status
	return base_data

func from_dictionary(data: Dictionary) -> void:
	super.from_dictionary(data)
	durability = data["durability"]
	equipped = data["equipped"]
	status = data["armor_status"]

