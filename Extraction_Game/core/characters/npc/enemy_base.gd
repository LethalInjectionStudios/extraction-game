class_name EnemyBase
extends Character

@export var sprite: Sprite2D
@export var health_component: HealthComponent
@export var weapon_component: WeaponComponent
@export var hitbox_component: HitBoxComponent
@export var detection_component: DetectionComponent
@export var idle_state: Idle
@export var wander_state: Wander
@export var engaged_state: Engaged
@export var alert_state: Alert
@onready var state: Label = $Label
@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	_validate()
	_move_speed = 25.0


	var weapon: InventoryItemWeapon = InventoryItemWeapon.new()
	
	var weapon_data: Weapon = load("res://core/items/weapons/dev/ak47.tres")

	weapon.item_name = weapon_data.name
	weapon.item_type = weapon_data.type
	weapon.item_path = "res://core/items/weapons/dev/ak47.tres"
	weapon.ammo_type = "res://core/items/ammunition/resource/_762x39.tres"
	weapon.ammo_count = 30
	
	weapon_component.equip_weapon(weapon)

	
func _process(_delta: float) -> void:
	_update_sprites()
	state.text = state_machine.current_state.to_string()

	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func sound_heard(sound_position: Vector2) -> void:
	alerted.emit(sound_position)
	

func _update_sprites() -> void:	
	z_index = global_position.y as int
			
	if state_machine.current_state.name.to_lower() != "engaged":	
		if velocity.x < 0:
			sprite.flip_h = true
			weapon_component.weapon_sprite.flip_h = true
		if velocity.x > 0:
			sprite.flip_h = false
			weapon_component.weapon_sprite.flip_h = false


func _validate() -> void:
	if hitbox_component:
		hitbox_component.connect("hit_taken", health_component.damage)
		hitbox_component.connect("zombie_hit_taken", health_component.zombie_damage)
	else:
		push_error("Missing Hitbox Component on: ", self)
		
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
