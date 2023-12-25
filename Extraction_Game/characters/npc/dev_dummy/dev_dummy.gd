extends CharacterBody2D


var health: int = 100

func hit() -> void:
	health -= 50
	
	if health <= 0:
		queue_free()

func _on_timer_timeout():
	$AudioStreamPlayer2D.play()
	#$Timer.start()
