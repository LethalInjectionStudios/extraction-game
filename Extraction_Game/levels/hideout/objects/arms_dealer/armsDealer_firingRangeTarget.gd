class_name FireRangeTarget
extends StaticBody2D

@export var hitbox_component: HitBoxComponent

func _ready():
	_connect_signals()
	
	
func _connect_signals():
	hitbox_component.connect("hit_taken", _on_hit_taken)
	
	
func _on_hit_taken(projectile: Projectile):
	print(projectile.damage)
