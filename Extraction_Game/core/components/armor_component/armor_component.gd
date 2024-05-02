class_name ArmorComponent
extends Node2D

signal net_damage_taken(damage: int)
signal armor_removed_from_inventory(armor: InventoryItemArmor)
signal armor_added_to_invetory(armor: InventoryItemArmor)

var armor: Armor
var _armor_inventory_item: InventoryItemArmor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func damage(projectile: Projectile) -> void:
	if armor and _armor_inventory_item.status != Globals.Armor_Status.BROKEN:
		var penetration_modifer: int = projectile.armor_penetration - armor.armor_class * 10
		#System.print("AP: {0} - Armor: {1} - Pen_Modifier: {2}", [projectile.armor_penetration, armor.armor_class * 10, penetration_modifer])
		if _armor_inventory_item.status == Globals.Armor_Status.DAMAGED:
			print("Armor Broken")
			penetration_modifer += 15
		if clamp((randi_range(0, 100) + penetration_modifer), 10, 90) >= 50:
			_armor_inventory_item.durability -= (projectile.damage * .15)
			net_damage_taken.emit(projectile.damage)
		else:
			_armor_inventory_item.durability -= (projectile.damage * .15)
			
		_check_armor_status()
		
	else:
		net_damage_taken.emit(projectile.damage)
		print("No Armor")
		
func equip_armor(new_armor: InventoryItemArmor) -> void:
	
	if armor:
		unequip_armor()
		
	armor_removed_from_inventory.emit(new_armor)	
	
	armor = load(new_armor.item_path)
	_armor_inventory_item = new_armor
	_armor_inventory_item.equipped = true
	
	
func unequip_armor() -> void:
	_armor_inventory_item.equipped = false
	armor_added_to_invetory.emit(_armor_inventory_item)
	
	armor = null
	_armor_inventory_item = null


func _check_armor_status() -> void:
	
	if _armor_inventory_item.durability <= 60 and _armor_inventory_item.status != Globals.Armor_Status.DAMAGED:
		_armor_inventory_item.status = Globals.Armor_Status.DAMAGED
		
	if _armor_inventory_item.durability <= 35 and _armor_inventory_item.status != Globals.Armor_Status.BROKEN:
		_armor_inventory_item.status = Globals.Armor_Status.BROKEN
