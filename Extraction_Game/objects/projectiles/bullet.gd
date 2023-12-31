extends Area2D
class_name Projectile

var speed: int = 500
var direction: Vector2 = Vector2.UP
var ownerActor

func _process(delta):
	position += direction * speed * delta
	
func _on_body_entered(body):
	if "hit" in body:
		if body != ownerActor:
			body.hit()
			queue_free()
