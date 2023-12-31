extends CharacterBody2D

signal fire(projectile)

var enteredBody = null
var fired: bool = false
var bullet_scene: PackedScene = preload("res://objects/projectiles/bullet.tscn")

var health: int = 100

func _process(delta):
	if enteredBody != null:
		#$CharacterSprite/WeaponSprite.look_at(enteredBody.global_position)
		
		if enteredBody.global_position.x < position.x:
			$CharacterSprite.flip_h = true
			#$CharacterSprite/WeaponSprite.flip_v = true	
		else:
			$CharacterSprite.flip_h = false
			#$CharacterSprite/WeaponSprite.flip_v = false
			
		if not fired:	
			var bullet = bullet_scene.instantiate() as Projectile
			var gun_direction = (enteredBody.position - $CharacterSprite/WeaponSprite.global_position).normalized()
			bullet.global_position = position
			bullet.global_rotation = $CharacterSprite/WeaponSprite.rotation
			bullet.direction = gun_direction
			bullet.ownerActor = self
			fire.emit(bullet)
			$AudioStreamPlayer2D.play()
			fired = true
			$Timer.start()

func hit() -> void:
	health -= 50
	
	if health <= 0:
		queue_free()

func _on_timer_timeout():
	fired = false

func _on_area_2d_body_entered(body):
	enteredBody = body

func _on_area_2d_body_exited(body):
	enteredBody = null
