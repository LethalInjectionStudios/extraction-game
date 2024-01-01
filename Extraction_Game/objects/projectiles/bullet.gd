class_name Projectile
extends Area2D

var damage: int = 50
var armor_penetration: int = 0
var speed: int = 500
var range: int = 250
var recoil: int
var direction: Vector2 = Vector2.UP
var owner_actor

var _distance_traveled: float

func _process(delta):
	position += direction * speed * delta
	_distance_traveled = position.distance_to(owner_actor.position)
	
	if _distance_traveled > range:
		damage = damage / 2
		
	if _distance_traveled > range * 2:
		queue_free()


func _on_body_entered(body):
	if "hit" in body:
		if body != owner_actor:
			body.hit(damage, armor_penetration)
			queue_free()
