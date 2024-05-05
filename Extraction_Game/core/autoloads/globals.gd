extends Node

enum FireMode {
	SEMI,
	FULL
}

enum Caliber {
	_9MM,
	_762X39,
	_762X51NATO
}

func get_caliber_as_string(caliber: Caliber) -> String:
	var caliber_string: String = String()
	
	match caliber:
		Globals.Caliber._9MM:
			caliber_string = "9mm"
		Globals.Caliber._762X39:
			caliber_string = "7.62 x 39"
		Globals.Caliber._762X51NATO:
			caliber_string = "7.52 x 51 NATO"
	
	return caliber_string

enum Armor_Status {
	UNDAMAGED,
	DAMAGED,
	BROKEN
}

func get_armor_status_as_string(armor: Armor_Status) -> String:
	var armor_status_string: String = String()
	
	match armor:
		Globals.Armor_Status.UNDAMAGED:
			armor_status_string = "Undamaged"
		Globals.Armor_Status.DAMAGED:
			armor_status_string = "Damaged"
		Globals.Armor_Status.BROKEN:
			armor_status_string = "Broken"
	
	return armor_status_string

enum Faction {
	NONE_ASSIGNED,
	PLAYER,
	ZOMBIE,
	SCAVENGERS,
	MILITARY
}

enum Item_Type {
	JUNK,
	WEAPON,
	AMMO,
	MEDICATION,
	FOOD,
	WATER,
	CRAFTING_MATERIAL,
	ARMOR
}

func get_item_type_as_string(type: Item_Type) -> String:
	var item_type_string: String = String()
	
	match type:
		Globals.Item_Type.JUNK:
			item_type_string = "Junk"
		Globals.Item_Type.WEAPON:
			item_type_string = "Weapon"
		Globals.Item_Type.AMMO:
			item_type_string = "Ammo"
		Globals.Item_Type.MEDICATION:
			item_type_string = "Medication"
		Globals.Item_Type.FOOD:
			item_type_string = "Consumable"
		Globals.Item_Type.WATER:
			item_type_string = "Consumable"
		Globals.Item_Type.CRAFTING_MATERIAL:
			item_type_string = "Material"
		Globals.Item_Type.ARMOR:
			item_type_string = "Armor"
			
	return item_type_string

enum Interactable_Type {
	LOOTABLE,
	MAP
}

var next_scene: String = "res://core/levels/forest/forest.tscn"
var negative_weapon_component_scale: float = -0.5
var positive_weapon_component_scale: float = 0.5
