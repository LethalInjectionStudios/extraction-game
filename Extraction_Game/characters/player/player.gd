class_name Player
extends Character

signal ui_changed()

const MAX_HUNGER: int = 100
const MAX_THIRST: int = 100
const FACTION: Globals.Factions = Globals.Factions.PLAYER

var _hunger: int
var _thirst: int
var _inRaid: bool = false

@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var hunger_timer: Timer = $Timers/HungerTimer
@onready var thirst_timer: Timer = $Timers/ThirstTimer
@onready var weapon_component: WeaponComponent = $Components/WeaponComponent
@onready var health_component: HealthComponent = $Components/HealthComponent
@onready var ui: HeadsUpDisplay = $HeadsUpDisplay

func _ready():
	_hunger = MAX_HUNGER
	_thirst = MAX_THIRST
	
	ui_changed.emit()

func _process(_delta):
	_update_sprites()
	_get_input()


func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * move_speed
	move_and_slide()


func _update_sprites() -> void:	
	if get_global_mouse_position().x < position.x:
		player_sprite.flip_h = true
		weapon_component.weapon_sprite.scale.y = Globals.negative_weapon_component_scale
	else:
		player_sprite.flip_h = false
		weapon_component.weapon_sprite.scale.y = Globals.positive_weapon_component_scale
		
	weapon_component.weapon_sprite.look_at(get_global_mouse_position())


func _get_input() -> void:
	if Input.is_action_pressed("fire"):
		weapon_component.fire_weapon(get_global_mouse_position())
		ui_changed.emit()
		
	if Input.is_action_just_released("reload"):
		weapon_component.reload_weapon()
		ui_changed.emit()
		
	if Input.is_key_pressed(KEY_Q):
		weapon_component.equip_weapon("res://resources/weapons/ar.tres")
		
	if Input.is_key_pressed(KEY_E):
		weapon_component.unequip_weapon()


func _on_hunger_timer_timeout():
	_hunger -= 1
	ui_changed.emit()
	hunger_timer.start()


func _on_thirst_timer_timeout():
	_thirst -= 1
	ui_changed.emit()
	thirst_timer.start()
	
func get_faction() -> Globals.Factions:
	return FACTION
