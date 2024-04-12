class_name FireRangeTarget
extends StaticBody2D

@export var hitbox_component: HitBoxComponent

func _ready() -> void:
	_connect_signals()
	
	
func _connect_signals() -> void:
	hitbox_component.connect("hit_taken", _on_hit_taken)
	
	
func _on_hit_taken(projectile: Projectile) -> void:
	print(projectile.damage)
