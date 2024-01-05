class_name HealthComponent
extends Node2D

@export var parent: Character
@export var MAX_HEALTH: int

var _health: int

func _ready():
	_health = MAX_HEALTH


func damage(projectile: Projectile) -> void:
	_health -= projectile.damage
	
	if parent is Player:
		var player: Player = parent
		player.ui.update_display()
	
	if _health <= 0:
		parent.queue_free()
		
func zombie_damage(damage: int):
	_health -= damage
	
	if parent is Player:
		var player: Player = parent
		player.ui.update_display()
	
	if _health <= 0:
		parent.queue_free()
