class_name HealthComponent
extends Node2D

signal damage_taken()
signal destroyed()

@export var MAX_HEALTH: int = 100

var _health: int

func _ready():
	_health = MAX_HEALTH


func damage(projectile: Projectile) -> void:
	_health -= projectile.damage
	check_health()


func zombie_damage(_damage: int):
	_health -= _damage
	check_health()


func check_health():
	if _health > 0:
		damage_taken.emit()

	if _health <= 0:
		destroyed.emit()