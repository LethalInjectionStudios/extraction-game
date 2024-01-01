class_name Projectile
extends Area2D

var damage: int = 50
var armor_penetration: int = 0
var speed: int = 500
var recoil: int
var direction: Vector2 = Vector2.UP
var owner_actor


func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	if "hit" in body:
		if body != owner_actor:
			body.hit(damage, armor_penetration)
			queue_free()
