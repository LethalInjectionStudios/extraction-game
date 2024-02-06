class_name DevDummy
extends Character

var enteredBody = null
var bullet_scene: PackedScene = preload("res://objects/projectiles/bullet.tscn")

@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var weapon_component: WeaponComponent = $WeaponComponent

func _ready():
	_faction = Globals.Factions.SCAVENGERS
	#weapon_component.equip("res://resources/weapons/dev_gun.tres")

func _process(_delta):
	if enteredBody != null:
		_update_sprites()
		
		if weapon_component.magazine_count > 0 and not weapon_component.reload_audio.playing:
			weapon_component.fire_weapon(enteredBody.position)

		if weapon_component.magazine_count == 0 and not weapon_component.reload_audio.playing:
			weapon_component.reload_weapon()


func _update_sprites() -> void:	
	weapon_component.weapon_sprite.look_at(enteredBody.global_position)
	
	if enteredBody.global_position.x < position.x:
		character_sprite.flip_h = true
		weapon_component.weapon_sprite.scale.y = -0.5
	else:
		character_sprite.flip_h = false
		weapon_component.weapon_sprite.scale.y = 0.5
