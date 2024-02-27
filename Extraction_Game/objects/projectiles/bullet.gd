class_name Projectile
extends Area2D

var damage: int = 50
var armor_penetration: int = 0
var speed: int = 500
var recoil: int
var direction: Vector2 = Vector2.UP
var parent: Character


func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_area_entered(area: Node2D) -> void:	
	if area is HitBoxComponent:
		if area.parent != parent:
			var hitbox: HitBoxComponent = area
			hitbox.hit(self)
			queue_free()	
	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Tilemap"):
		queue_free()
