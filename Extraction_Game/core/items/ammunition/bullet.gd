class_name Projectile
extends Area2D

var damage: int
var armor_penetration: int = 0
var speed: int = 500
var recoil: int
var direction: Vector2 = Vector2.UP
var sound_emmitted: int
var parent: Character


func _process(delta: float) -> void:
	position += direction * speed * delta


func setup(base_damage: int, bullet: Ammunition, 
			spawn_position: Vector2, spawn_rotation: float, direction_fired: Vector2, ) -> void:
	damage = base_damage + (base_damage * bullet.damage_modifier)
	armor_penetration = bullet.armor_penetration
	global_position = spawn_position
	global_rotation = spawn_rotation
	direction = direction_fired


func _on_area_entered(area: Node2D) -> void:	
	if area is HitBoxComponent:
		if area.parent != parent:
			var hitbox: HitBoxComponent = area
			hitbox.hit(self)
			queue_free()	
	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Tilemap"):
		queue_free()
