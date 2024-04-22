class_name HealthComponent
extends Node2D

signal damage_taken()
signal destroyed()

@export var MAX_HEALTH: int = 100

var _health: int

func _ready() -> void:
	_health = MAX_HEALTH


func damage(projectile: Projectile) -> void:
	_health -= projectile.damage
	check_health()


func zombie_damage(damage_value: int) -> void:
	_health -= damage_value
	check_health()


func heal(health_amount: int) -> void:
	_health += health_amount

	if _health > MAX_HEALTH:
		_health = MAX_HEALTH


func check_health() -> void:
	if _health > 0:
		damage_taken.emit()

	if _health <= 0:
		destroyed.emit()
