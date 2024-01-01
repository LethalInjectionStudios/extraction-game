class_name WeaponComponent
extends Node2D

signal weapon_fired(projectile)

const BULLET_SCENE: PackedScene = preload("res://objects/projectiles/bullet.tscn")

var durability: float
var max_durabiity: float = 100.0
var range: int
var rate_of_fire: float
var caliber
var loaded_ammo
var accuracy
var recoil
var ergonomics
var magazine_capacity: int = 30
var magazine_count: int = 30
var weapon
var stock
var grip
var handguard
var barrel
var magazine
var muzzle
var scope
var foregrip
var light

var _can_fire: bool = true
var _stock_position: Vector2
var _grip_position: Vector2
var _handguard_position: Vector2
var _barrel_position: Vector2
var _magazine_position: Vector2
var _muzzle_position: Vector2 = Vector2(6, -2.5)
var _scope_position: Vector2
var _foregrip_position: Vector2
var _light_position: Vector2

@onready var owning_actor = get_parent()
@onready var gun_sprite: Sprite2D = $GunSprite
@onready var muzzle_sprite: Sprite2D  = $GunSprite/MuzzleSprite
@onready var bullet_location: Marker2D  = $GunSprite/BulletLocation
@onready var gunshot_audio: AudioStreamPlayer2D = $Audio/GunshotAudio
@onready var empty_magazine_audio: AudioStreamPlayer2D = $Audio/EmptyMagazineAudio
@onready var reload_audio: AudioStreamPlayer2D = $Audio/ReloadAudio
@onready var rate_of_fire_timer: Timer = $Timers/RateOfFire
@onready var reload_timer: Timer = $Timers/ReloadTimer

func _ready():
	muzzle_sprite.position = _muzzle_position


func _process(delta):
	pass


#TODO: Move bullet creation logic to its own function
func fire_weapon(target) -> void:
	if not _can_fire:
		return
		
	if magazine_count > 0:
		_can_fire = false
		var bullet = BULLET_SCENE.instantiate() as Projectile
		var gun_direction = (target - gun_sprite.global_position).normalized()
		bullet.global_position = bullet_location.global_position
		bullet.global_rotation = gun_sprite.rotation
		bullet.direction = gun_direction
		bullet.owner_actor = owning_actor
		weapon_fired.emit(bullet)
		gunshot_audio.play()
		rate_of_fire_timer.start()
		magazine_count -= 1
	else:
		if not empty_magazine_audio.playing:
			empty_magazine_audio.play()


#TODO: Check how much ammo is left in inventory
func reload_weapon() -> void:
	if magazine_count < magazine_capacity and not reload_audio.playing:
		magazine_count = magazine_capacity
		_can_fire = false
		reload_audio.play()
		reload_timer.start()


func _on_rate_of_fire_timeout():
	_can_fire = true


func _on_reload_timer_timeout():
	_can_fire = true
