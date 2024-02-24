class_name EnemyBase
extends Character

@export var detection_component: DetectionComponent
@export var weapon_component: WeaponComponent
@export var sprite: Sprite2D

@export var engaged_state: Engaged

@onready var state:Label = $Label
@onready var sm:StateMachine = $StateMachine

func _ready() -> void:
	_move_speed = 25.0
	detection_component.connect("actor_entered", _on_actor_entered_detection_component)
	detection_component.connect("actor_left", _on_actor_left_detection_component)

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
	update_sprites()
	state.text = sm.current_state.to_string()
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	

func update_sprites() -> void:			
	if $StateMachine.current_state.name.to_lower() != "engaged":	
		if velocity.x < 0:
			$Sprite.flip_h = true
			weapon_component.weapon_sprite.scale.y = Globals.negative_weapon_component_scale
		if velocity.x > 0:
			$Sprite.flip_h = false
			weapon_component.weapon_sprite.scale.y = Globals.positive_weapon_component_scale


func _on_actor_entered_detection_component(body: Node2D) -> void:
	if body != self:
		engaged_state._add_nearby_actor(body)


func _on_actor_left_detection_component(body: Node2D) -> void:
	engaged_state._remove_nearby_actor(body)
