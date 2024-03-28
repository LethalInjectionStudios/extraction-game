class_name SandBag
extends StaticBody2D

func _on_area_2d_area_entered(area:Area2D) -> void:
	#if area is Projectile:
	#var b = area as Projectile
	var bullet_direciton: Vector2 = Vector2(1, 0).rotated(area.rotation)
	var self_direction: Vector2 = Vector2(1,0).rotated(rotation)
	
	var dot_product: float = bullet_direciton.dot(self_direction)

	if(dot_product > 0.15):
		pass
	else:
		area.queue_free()

