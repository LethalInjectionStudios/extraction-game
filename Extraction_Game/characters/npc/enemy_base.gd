class_name EnemyBase
extends Character

@onready var weapon_component = $Components/WeaponComponent

func _ready():	
	weapon_component.equip_weapon("res://resources/weapons/dev_gun.tres")

	
func _process(_delta):
	if velocity.x < 0:
		$Sprite.flip_h = true
	if velocity.x > 0:
		$Sprite.flip_h = false
		
	if $StateMachine.current_state.name.to_lower() != "fight":
		if velocity.x < 0:
			weapon_component.weapon_sprite.scale.x = -0.5
		if velocity.x > 0:
			weapon_component.weapon_sprite.scale.x = 0.5

	
func _physics_process(_delta):
	move_and_slide()
