class_name RandomLootable
extends Lootable

@export var drops: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !drops.is_empty():
		for i: int in range(randi_range(0,5)):
			var res: Item = load(drops[randi_range(0, drops.size() - 1)])

			if res.type == Globals.Item_Type.WEAPON:
				var item: InventoryItemWeapon = InventoryItemWeapon.new()
				var weapon: Weapon = load(res.resource_path) as Weapon

				item.item_name = res.name
				item.item_path = res.resource_path
				item.item_type = res.type
				item.item_icon = res.icon
				item.ammo_type = Globals.get_ammo_from_caliber(weapon.caliber)
				item.durability = randi_range(50, 100)


				inventory_component._add_to_inventory(item)

			if res.type == Globals.Item_Type.MEDICATION:
				var item: InventoryItemConsumable = InventoryItemConsumable.new()

				item.item_name = res.name
				item.item_path = res.resource_path
				item.item_type = res.type
				item.item_icon = res.icon

				inventory_component._add_to_inventory(item)
				
			if res.type == Globals.Item_Type.CONSUMABLE:
				var item: InventoryItemConsumable = InventoryItemConsumable.new()

				item.item_name = res.name
				item.item_path = res.resource_path
				item.item_type = res.type
				item.item_icon = res.icon

				inventory_component._add_to_inventory(item)
				
			if res.type == Globals.Item_Type.AMMO:
				var item: InventoryItemAmmo = InventoryItemAmmo.new()		
				item.item_name = res.name
				item.item_path = res.resource_path
				item.item_type = res.type
				item.item_icon = res.icon
				item.quantity = randi_range(50, 100)

				inventory_component._add_to_inventory(item)
				
			
			if res.type == Globals.Item_Type.CRAFTING_MATERIAL:
				var item: InventoryItemCraftingMaterial = InventoryItemCraftingMaterial.new()
				
				item.item_name = res.name
				item.item_path = res.resource_path
				item.item_type = res.type
				item.item_icon = res.icon
				item.quantity = randi_range(1, 25)

				inventory_component._add_to_inventory(item)
				
			if res.type == Globals.Item_Type.ARMOR:
				var item: InventoryItemArmor = InventoryItemArmor.new()
				
				item.item_name = res.name
				item.item_path = res.resource_path
				item.item_type = res.type
				item.item_icon = res.icon
				
				item.durability = randf_range(0.0, 100.0)
				
				inventory_component._add_to_inventory(item)			
