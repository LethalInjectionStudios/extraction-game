class_name Player
extends Character

signal ui_changed()

const MAX_HUNGER: int = 100
const MAX_THIRST: int = 100
const FACTION: Globals.Faction = Globals.Faction.PLAYER

var _hunger: int
var _thirst: int
#var _inRaid: bool = false
var _menu_open = false

var test : InventoryItem = InventoryItem.new()

@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var hunger_timer: Timer = $Timers/HungerTimer
@onready var thirst_timer: Timer = $Timers/ThirstTimer
@onready var weapon_component: WeaponComponent = $Components/WeaponComponent
@onready var health_component: HealthComponent = $Components/HealthComponent
@onready var inventory_component: InventoryComponent = $Components/InventoryComponent
@onready var ui: HeadsUpDisplay = $HeadsUpDisplay
@onready var inventory_ui: InventoryUI = $Inventory

func _ready():
	_hunger = MAX_HUNGER
	_thirst = MAX_THIRST
	
	ui_changed.emit()
	_load_character_data()

	_connect_signals()


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
	if Input.is_action_pressed("fire") and !_menu_open:
		weapon_component.fire_weapon(get_global_mouse_position())
		ui_changed.emit()
		
	if Input.is_action_just_released("reload") and !_menu_open:
		weapon_component.reload_weapon()
		ui_changed.emit()
		
	if Input.is_key_pressed(KEY_P):
		_save()

	if Input.is_action_just_pressed("inventory"):
		if !_menu_open:
			_menu_open = true
			inventory_ui.show_window()
			inventory_ui.open_inventory()
		else:
			_menu_open = false
			inventory_ui.hide_window()
			inventory_ui.close_inventory()


func _on_hunger_timer_timeout():
	_hunger -= 1
	ui_changed.emit()
	hunger_timer.start()


func _on_thirst_timer_timeout():
	_thirst -= 1
	ui_changed.emit()
	thirst_timer.start()
	

func get_faction() -> Globals.Faction:
	return FACTION
	
	
func _save() -> void:
	var save_path = "user://inventory.save"
	var file = FileAccess.open(save_path, FileAccess.WRITE)

	if file:
		for item in inventory_component.inventory.inventory:
			if item.item_type == Globals.Item_Type.WEAPON:
				var save_item = item as InventoryItemWeapon
				file.store_line(JSON.stringify((save_item.to_dictionary())))
		file.close()

	
func _load_character_data():
	inventory_component.inventory.inventory.clear()

	var save_path = "user://inventory.save"
	var file = FileAccess.open(save_path, FileAccess.READ)

	if file:
		while file.get_position() < file.get_length():
			var content = file.get_line()
			var item_data = JSON.parse_string(content)
			var _item_instance = null
			if item_data["item_type"] == Globals.Item_Type.WEAPON:
				_item_instance = InventoryItemWeapon.new()
				_item_instance.from_dictionary(item_data)
				inventory_component._add_to_inventory(_item_instance)
	else:
		print("File not found")



func _connect_signals() -> void:
	inventory_ui.connect("equip_weapon", weapon_component.equip_weapon)
	inventory_ui.connect("unequip_weapon", weapon_component.unequip_weapon)