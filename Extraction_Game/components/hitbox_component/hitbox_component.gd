class_name HitBoxComponent
extends Area2D

@export var health_component: HealthComponent

func hit(projectile: Projectile):
	print("Hit")
	health_component.damage(projectile)
