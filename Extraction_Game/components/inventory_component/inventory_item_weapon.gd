class_name InventoryItemWeapon
extends InventoryItem

var muzzle: String

var ammo_type: String
var ammo_count: int

func to_dictionary() -> Dictionary:
	var base_data: Dictionary = super.to_dictionary()
	base_data["muzzle"] = muzzle
	base_data["ammo"] = ammo_count
	base_data["ammo_type"] = ammo_type
	return base_data

func from_dictionary(data: Dictionary) -> void:
	super.from_dictionary(data)
	muzzle = data["muzzle"]
	ammo_count = data["ammo"]
	ammo_type = data["ammo_type"]

func test() -> void:
	super.test()
	print("Hello from weapon item")
