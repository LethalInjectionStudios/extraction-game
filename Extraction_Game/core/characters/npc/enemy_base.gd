class_name EnemyBase
extends Character

@export var sprite: Sprite2D
@export var health_component: HealthComponent
@export var weapon_component: WeaponComponent
@export var hitbox_component: HitBoxComponent
@export var detection_component: DetectionComponent
@export var armor_component: ArmorComponent
@export var idle_state: Idle
@export var wander_state: Wander
@export var engaged_state: Engaged
@export var alert_state: Alert

@onready var state: Label = $Label
@onready var state_machine: StateMachine = $StateMachine
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_validate()
	_move_speed = 25.0


	var weapon: InventoryItemWeapon = InventoryItemWeapon.new()
	
	var weapon_data: Weapon = load("res://core/items/weapons/automatic_rifles/jk47.tres")

	weapon.item_name = weapon_data.name
	weapon.item_type = weapon_data.type
	weapon.item_path = "res://core/items/weapons/automatic_rifles/jk47.tres"
	weapon.ammo_type = "res://core/items/ammunition/resource/_762x39_ps.tres"
	weapon.ammo_count = 30
	
	weapon_component.equip_weapon(weapon)
	
	var armor: InventoryItemArmor = InventoryItemArmor.new()
	
	var armor_data: Armor = load("res://core/items/armor/military_bdu.tres") as Armor
	
	armor.item_name = armor_data.name
	armor.item_type = armor_data.type
	armor.item_path = "res://core/items/armor/military_bdu.tres"
	
	sprite.texture = load(armor_data.character_sprite)
	


	
func _process(_delta: float) -> void:
	_update_sprites()
	state.text = state_machine.current_state.to_string()
	
	if velocity == Vector2.ZERO:
		_animation_player.play("idle")
		
	if velocity != Vector2.ZERO:
		_animation_player.play("walk")

	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func sound_heard(sound_position: Vector2) -> void:
	alerted.emit(sound_position)
	

func _update_sprites() -> void:	
	z_index = global_position.y as int
			
	if state_machine.current_state.name.to_lower() != "engaged":
		weapon_component.weapon_sprite.rotation = 0	
		if velocity.x < 0:
			sprite.flip_h = true
			weapon_component.weapon_sprite.flip_h = true
			weapon_component.weapon_sprite.z_index = sprite.z_index - 1
		if velocity.x > 0:
			sprite.flip_h = false
			weapon_component.weapon_sprite.flip_h = false
			weapon_component.weapon_sprite.z_index = sprite.z_index + 1


func _validate() -> void:
	if hitbox_component:
		hitbox_component.connect("hit_taken", armor_component.damage)
		hitbox_component.connect("zombie_hit_taken", health_component.zombie_damage)
	else:
		push_error("Missing Hitbox Component on: ", self)
		
	if armor_component:
		armor_component.net_damage_taken.connect(health_component.damage)
		
	if health_component:
		health_component.connect("destroyed", _on_actor_death)
	else:
		push_error("Missing Health Component on: ", self)
		
	if weapon_component:
		weapon_component.connect("weapon_reloaded", _on_weapon_reloaded)
	else:
		push_error("Missing Weapon Component on: ", self)
		
	if idle_state:
		idle_state.alerted.connect(_on_actor_alerted)
	else:
		push_error("Missing Idle State on: ", self)
		
	if wander_state:
		wander_state.alerted.connect(_on_actor_alerted)
	else:
		push_error("Missing Idle State on: ", self)
		
	if engaged_state:
		engaged_state.alerted.connect(_on_actor_alerted)
	else:
		push_error("Missing Engaged State on: ", self)
		
	if !alert_state:
		push_error("Missing Alert State on: ", self)


func _on_weapon_reloaded(_ammo: Ammunition, _magazine_capacity: int) -> void:
	weapon_component.magazine_count = weapon_component.magazine_capacity


func _on_actor_alerted(last_known_position: Vector2) -> void:
	alert_state.target_position = last_known_position
	
	
func _on_actor_death() -> void:
	queue_free()
