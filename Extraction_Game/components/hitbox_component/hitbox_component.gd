class_name HitBoxComponent
extends Area2D

signal hit_taken(projectile: Projectile)
signal zombie_hit_taken(damage: int)

@export var parent: Character
@export var health_component: HealthComponent

func hit(projectile: Projectile):
	hit_taken.emit(projectile)

func zombie_hit(damage: int):
	zombie_hit_taken.emit(damage)
