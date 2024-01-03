extends CharacterBody2D

var enteredBody = null
var bullet_scene: PackedScene = preload("res://objects/projectiles/bullet.tscn")
var health: int = 100

@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var weapon_component: WeaponComponent = $WeaponComponent

func _ready():
	pass #weapon_component.equip("res://resources/weapons/dev_gun.tres")

func _process(delta):
	if enteredBody != null:
		_update_sprites()
		
		if weapon_component.magazine_count > 0 and not weapon_component.reload_audio.playing:
			weapon_component.fire_weapon(enteredBody.position)

		if weapon_component.magazine_count == 0 and not weapon_component.reload_audio.playing:
			weapon_component.reload_weapon()


func hit(damage, armor_penetration) -> void:
	health -= damage
	
	if health <= 0:
		queue_free()


func _update_sprites() -> void:	
	weapon_component.weapon_sprite.look_at(enteredBody.global_position)
	
	if enteredBody.global_position.x < position.x:
		character_sprite.flip_h = true
		weapon_component.weapon_sprite.scale.y = -0.5
	else:
		character_sprite.flip_h = false
		weapon_component.weapon_sprite.scale.y = 0.5


func _on_area_2d_body_entered(body):
	enteredBody = body


func _on_area_2d_body_exited(body):
	enteredBody = null
