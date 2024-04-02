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
	HEALTH,
	FOOD,
	WATER,
	CRAFTING_MATERIAL
}

enum Interactable_Type {
	LOOTABLE,
	MAP
}

var negative_weapon_component_scale: float = -0.5
var positive_weapon_component_scale: float = 0.5
