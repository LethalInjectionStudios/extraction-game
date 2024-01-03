class_name HealthComponent
extends Node2D

@export var MAX_HEALTH: int

var _health: int

func _ready():
	_health = MAX_HEALTH


func damage(projectile: Projectile) -> void:
	_health -= projectile.damage
	
	if _health <= 0:
		get_parent().queue_free()
