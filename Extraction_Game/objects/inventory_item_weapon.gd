class_name InventoryItemWeapon
extends InventoryItem

var weapon_resource_path: String

var muzzle: String


func _ready():
	item_type = Globals.Item_Type.WEAPON


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
