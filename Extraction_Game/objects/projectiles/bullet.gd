extends Area2D
class_name Projectile

var speed: int = 500
var direction: Vector2 = Vector2.UP

func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	if "hit" in body:
		body.hit()
		
	queue_free()
