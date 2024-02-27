class_name EnemyBase
extends Character

@export var sprite: Sprite2D
@export var health_component: HealthComponent
@export var weapon_component: WeaponComponent
@export var hitbox_component: HitBoxComponent
@export var detection_component: DetectionComponent

@onready var state:Label = $Label
@onready var sm:StateMachine = $StateMachine

func _ready() -> void:
	_move_speed = 25.0
	_connect_signals()

	var weapon: InventoryItemWeapon = InventoryItemWeapon.new()
	
	if randi() % 2:
		var weapon_data: Weapon = load("res://resources/weapons/dev_gun.tres")

		weapon.item_name = weapon_data.name
		weapon.item_type = weapon_data.type
		weapon.item_path = "res://resources/weapons/dev_gun.tres"
		
		weapon_component.equip_weapon(weapon)
	else:
		var weapon_data: Weapon = load("res://resources/weapons/ar.tres")

		weapon.item_name = weapon_data.name
		weapon.item_type = weapon_data.type
		weapon.item_path = "res://resources/weapons/ar.tres"

		weapon_component.equip_weapon(weapon)

	
func _process(_delta: float) -> void:
	_update_sprites()
	state.text = sm.current_state.to_string()
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	

func _update_sprites() -> void:			
	if $StateMachine.current_state.name.to_lower() != "engaged":	
		if velocity.x < 0:
			sprite.flip_h = true
			weapon_component.weapon_sprite.flip_h = true
		if velocity.x > 0:
			sprite.flip_h = false
			weapon_component.weapon_sprite.flip_h = false




func _connect_signals() -> void:
	hitbox_component.connect("hit_taken", health_component.damage)
	hitbox_component.connect("zombie_hit_taken", health_component.zombie_damage)
	health_component.connect("destroyed", _on_actor_death)


func _on_actor_death() -> void:
	queue_free()
