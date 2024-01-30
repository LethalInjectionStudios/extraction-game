extends Node

enum FireMode {
	SEMI,
	FULL
}

enum Caliber {
	NINE_MM,
	SEVEN_SIX_TWO_X_THIRTYNINE_MM
}

enum Faction {
	NONE_ASSIGNED,
	PLAYER,
	ZOMBIE,
	SCAVENGERS
}

enum Item_Type {
	JUNK,
	WEAPON
}

var negative_weapon_component_scale: float = -0.5
var positive_weapon_component_scale: float = 0.5
