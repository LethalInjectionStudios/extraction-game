class_name WeaponComponent
extends Node2D

signal weapon_fired(projectile: Projectile)
signal noise_emitted(location: Vector2)
signal weapon_added_to_inventory(weapon: InventoryItemWeapon)
signal weapon_removed_from_inventory(weapon: InventoryComponent)

const BULLET_SCENE: PackedScene = preload("res://objects/projectiles/bullet.tscn")

var durability: float
var max_durabiity: float = 100.0
var weapon_range: int
var rate_of_fire: float
var firing_mode: Globals.FireMode
# var caliber
# var loaded_ammo
# var accuracy
# var recoil
# var ergonomics
var magazine_capacity: int
var magazine_count: int
var weapon: Weapon
var ammo: Ammunition
# var stock
# var grip
# var handguard
# var barrel
# var magazine
# var muzzle
# var scope
# var foregrip
# var light

var _can_fire: bool = true
var _inventory_item: InventoryItemWeapon
# var _stock_position: Vector2
# var _grip_position: Vector2
# var _handguard_position: Vector2
# var _barrel_position: Vector2
# var _magazine_position: Vector2
# var _muzzle_position: Vector2 = Vector2(6, -2.5)
# var _scope_position: Vector2
# var _foregrip_position: Vector2
# var _light_position: Vector2

@onready var weapon_sprite: Sprite2D = $GunSprite
@onready var muzzle_sprite: Sprite2D  = $GunSprite/MuzzleSprite
@onready var bullet_location: Marker2D  = $GunSprite/BulletLocation
@onready var audio_node: Node2D = $Audio
@onready var gunshot_audio: AudioStreamPlayer2D = $Audio/GunshotAudio
@onready var empty_magazine_audio: AudioStreamPlayer2D = $Audio/EmptyMagazineAudio
@onready var reload_audio: AudioStreamPlayer2D = $Audio/ReloadAudio
@onready var rate_of_fire_timer: Timer = $Timers/RateOfFire
@onready var reload_timer: Timer = $Timers/ReloadTimer

func _ready() -> void:
	ammo = load("res://resources/ammunition/_762x39.tres")

func _process(_delta: float) -> void:
	audio_node.global_position = owner.global_position


func fire_weapon(target: Vector2) -> void:
	if _can_fire and weapon:		
		if magazine_count > 0:
			_can_fire = false
			rate_of_fire_timer.start()
			noise_emitted.emit(global_position)
			_create_bullet(target)
		else:
			if not empty_magazine_audio.playing:
				empty_magazine_audio.play()

	
func equip_weapon(_weapon: InventoryItemWeapon) -> void:
	if weapon:
		unequip_weapon()
	weapon_removed_from_inventory.emit(_weapon)
	_inventory_item = _weapon
	weapon = load(_weapon.item_path) as Weapon
	weapon_sprite.texture = load(weapon.sprite)
	if _weapon.muzzle:
		muzzle_sprite.texture = load(_weapon.muzzle)
	rate_of_fire = weapon.rate_of_fire
	rate_of_fire_timer.wait_time = rate_of_fire
	firing_mode = weapon.firing_mode
	magazine_capacity = weapon.magazine_size
	magazine_count = _weapon.ammo_count
	
func unequip_weapon() -> void:
	_inventory_item.ammo_count = magazine_count
	weapon_added_to_inventory.emit(_inventory_item)
	_inventory_item = null
	weapon = null
	weapon_sprite.texture = null
	muzzle_sprite.texture = null
	rate_of_fire_timer.wait_time = 1.0
	magazine_capacity = 0
	magazine_count = 0
	
	
#TODO: Check how much ammo is left in inventory
func reload_weapon() -> void:
	if magazine_count < magazine_capacity and not reload_audio.playing and weapon:
		magazine_count = magazine_capacity
		_can_fire = false
		reload_audio.play()
		reload_timer.start()


func _create_bullet(target: Vector2) -> void:
	var bullet: Projectile = BULLET_SCENE.instantiate() as Projectile
	var weapon_direction: Vector2 = (target - weapon_sprite.global_position).normalized()
	bullet.setup(weapon.damage, ammo, bullet_location.global_position, weapon_sprite.rotation, weapon_direction)
	weapon_fired.emit(bullet)
	gunshot_audio.play()
	rate_of_fire_timer.start()
	magazine_count -= 1


func _on_rate_of_fire_timeout() -> void:
	_can_fire = true


func _on_reload_timer_timeout() -> void:
	_can_fire = true
