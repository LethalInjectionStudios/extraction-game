class_name HitBoxComponent
extends Area2D

@export var parent: Character
@export var health_component: HealthComponent

func hit(projectile: Projectile):
	if health_component:
		health_component.damage(projectile)

func zombie_hit(damage: int):
	if health_component:
		health_component.zombie_damage(damage)
