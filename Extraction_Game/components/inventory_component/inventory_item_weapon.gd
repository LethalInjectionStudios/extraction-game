class_name InventoryItemWeapon
extends InventoryItem

var weapon_resource_path: String

var muzzle: String

func to_dictionary() -> Dictionary:
	var base_date = super.to_dictionary()
	base_date["muzzle"] = muzzle
	return base_date

func from_dictionary(data: Dictionary):
	super.from_dictionary(data)
	muzzle = data["muzzle"]

func test():
	super.test()
	print("Hello from weapon item")
