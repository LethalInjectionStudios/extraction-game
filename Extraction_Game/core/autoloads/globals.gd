extends Node

enum FireMode {
	SEMI,
	FULL
}

enum Caliber {
	MISSING,
	_762x39,
	_9x18,
	_9x19,
	_57x28,
	_545x39,
	_556x45,
	_762x25,
	_12GAUGE
}

func get_caliber_as_string(caliber: Caliber) -> String:
	var caliber_string: String = String()
	
	#match caliber:
		#Globals.Caliber._9MM:
			#caliber_string = "9mm"
		#Globals.Caliber._762X39:
			#caliber_string = "7.62 x 39"
		#Globals.Caliber._762X51NATO:
			#caliber_string = "7.52 x 51 NATO"
		#Globals.Caliber._556X45NATO:
			#caliber_string = "5.56 x 45 NATO"
	
	return caliber_string
	
func get_ammo_from_caliber(caliber: Caliber) -> String:
	var ammo_path: String = String()
	
	match caliber:
		#Globals.Caliber._9MM:
			#push_warning("Ammo Path not set for 9mm")
		#Globals.Caliber._762X39:
			#ammo_path = "res://core/items/ammunition/resource/_762x39_ps.tres"
		#Globals.Caliber._762X51NATO:
			#push_warning("Ammo Path not set for 7.62x39 NATO")
		#Globals.Caliber._556X45NATO:
			#push_warning("Ammo Path not set for 5.56x45 NATO")
		_:
			push_warning("Caliber Does not have a case created")

	
	return ammo_path

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
	DEPRECATED_FOOD,
	DEPRECATED_WATER,
	CRAFTING_MATERIAL,
	ARMOR,
	CONSUMABLE
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
		Globals.Item_Type.CRAFTING_MATERIAL:
			item_type_string = "Material"
		Globals.Item_Type.ARMOR:
			item_type_string = "Armor"
		Globals.Item_Type.CONSUMABLE:
			item_type_string = "Consumable"
			
	return item_type_string

enum Interactable_Type {
	LOOTABLE,
	MAP
}

var next_scene: String = "res://core/levels/forest/forest.tscn"
var negative_weapon_component_scale: float = -0.5
var positive_weapon_component_scale: float = 0.5
