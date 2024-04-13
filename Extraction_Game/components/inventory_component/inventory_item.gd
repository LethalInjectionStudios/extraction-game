class_name InventoryItem
extends Resource

var item_name: String
var item_type: Globals.Item_Type
var item_icon: String
var item_path: String

func to_dictionary() -> Dictionary:
	return {
		"item_name": item_name,
		"item_type": item_type,
		"item_icon": item_icon,
		"item_path": item_path
	}

func from_dictionary(data: Dictionary) -> void:
	item_name = data["item_name"]
	item_type = data["item_type"]
	item_icon = data["item_icon"]
	item_path = data["item_path"]
