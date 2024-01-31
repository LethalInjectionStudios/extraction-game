class_name EnemyBase
extends Character

@onready var weapon_component = $Components/WeaponComponent
@onready var sprite = $Sprite

func _ready():
	pass	
	#var rand = randi() % 2
	
	#if rand:
		#weapons_component.equip_weapon("res://resources/weapons/dev_gun.tres")
	#else:
		#weapon_component.equip_weapon("res://resources/weapons/ar.tres")

	
func _process(_delta):
	update_sprites()

	
func _physics_process(_delta):
	move_and_slide()
	

func update_sprites():			
	if $StateMachine.current_state.name.to_lower() != "engaged":	
		if velocity.x < 0:
			$Sprite.flip_h = true
			weapon_component.weapon_sprite.scale.y = Globals.negative_weapon_component_scale
		if velocity.x > 0:
			$Sprite.flip_h = false
			weapon_component.weapon_sprite.scale.y = Globals.positive_weapon_component_scale
