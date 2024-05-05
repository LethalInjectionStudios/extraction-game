class_name FireRangeTarget
extends StaticBody2D

@export_subgroup("Components")
@export var hitbox_component: HitBoxComponent

@export_subgroup("Properties")
## Armor Class of Armor (1 - 6)
@export_range (1, 6) var armor_value: int

func _ready() -> void:
	_connect_signals()
	
	
func _connect_signals() -> void:
	hitbox_component.connect("hit_taken", _on_hit_taken)
	
	
func _on_hit_taken(projectile: Projectile) -> void:
	var penetration_modifer: int = projectile.armor_penetration - armor_value * 10
	System.print("AP: {0} - Armor: {1} - Pen_Modifier: {2}", [projectile.armor_penetration, armor_value * 10, penetration_modifer])
	if randi_range(0, 100) + penetration_modifer >= 50:
		System.print("Bullet Penetrated")
	else:
		System.print("Failed to Penetrate")
	#System.print("{0} took {1} damage", [self, projectile.damage])
