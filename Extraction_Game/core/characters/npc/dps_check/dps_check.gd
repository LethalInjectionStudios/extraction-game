class_name DPSCheck
extends StaticBody2D

@export var hitbox_component: HitBoxComponent

func _ready() -> void:
	_validate()
	
	
func _validate() -> void:
	if hitbox_component:
		hitbox_component.hit_taken.connect(_on_actor_hit)
		

func _on_actor_hit(projectile: Projectile) -> void:
	System.log("{0} hit with {1} damage", [self, projectile.damage])
