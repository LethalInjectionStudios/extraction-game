class_name Player
extends Character

signal ui_changed()
signal inventory_toggled(player: Player)
signal interacted_with_lootable(player: Player, loot: Lootable)

const MAX_HUNGER: int = 100
const MAX_THIRST: int = 100
const FACTION: Globals.Faction = Globals.Faction.PLAYER

var menu_open: bool = false

var _hunger: int
var _thirst: int
var _in_raid: bool
var _interacting_object : Interactable

@onready var player_sprite: Sprite2D = $Sprite
@onready var hunger_timer: Timer = $Timers/HungerTimer
@onready var thirst_timer: Timer = $Timers/ThirstTimer

@onready var weapon_component: WeaponComponent = $Components/WeaponComponent
@onready var health_component: HealthComponent = $Components/HealthComponent
@onready var inventory_component: InventoryComponent = $Components/InventoryComponent
@onready var hitbox_component: HitBoxComponent = $Components/HitBoxComponent
@onready var interaction_component: DetectionComponent = $Components/InteractionDetectionComponent

@onready var ui: HeadsUpDisplay = $HeadsUpDisplay
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	_hunger = MAX_HUNGER
	_thirst = MAX_THIRST
	
	ui_changed.emit()

	_connect_signals()
	_load_character_data()


func _process(_delta: float) -> void:
	_update_sprites()
	_get_input()
	z_index = position.y as int
	move_and_slide()


func _physics_process(_delta: float) -> void:
	if !menu_open:
		var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = direction * _move_speed



func get_faction() -> Globals.Faction:
	return _faction


func _connect_signals() -> void:
	if weapon_component:
		weapon_component.connect("weapon_added_to_inventory", inventory_component._add_to_inventory)
		weapon_component.connect("weapon_removed_from_inventory", inventory_component._remove_from_inventory)
		weapon_component.connect("weapon_reloaded", _on_weapon_reloaded)
	else:
		push_warning("Missing Weapon Component on: ", self)
		
	if hitbox_component:
		hitbox_component.connect("hit_taken", health_component.damage)
		hitbox_component.connect("zombie_hit_taken", health_component.zombie_damage)
	else:
		push_warning("Missing Hitbox Component on: ", self)
		
	if health_component:
		health_component.connect("damage_taken", ui.update_display)
		health_component.connect("destroyed", _player_death)
	else:
		push_warning("Missing Health Component on: ", self)
		
	if interaction_component:
		interaction_component.connect("actor_entered", _start_interacting)
		interaction_component.connect("actor_left", _stop_interacting)
	else:
		push_warning("Missing Interaction Component on: ", self)


func _get_input() -> void:

	if _in_raid:
		if weapon_component.firing_mode == Globals.FireMode.FULL:
			if Input.is_action_pressed("fire") and !menu_open:
				weapon_component.fire_weapon(get_global_mouse_position())
				ui_changed.emit()

		if weapon_component.firing_mode == Globals.FireMode.SEMI:
			if Input.is_action_just_pressed("fire") and !menu_open:
				weapon_component.fire_weapon(get_global_mouse_position())
				ui_changed.emit()

	if Input.is_action_just_released("reload") and !menu_open:
		weapon_component.reload_weapon()
		ui_changed.emit()
		
	if Input.is_key_pressed(KEY_P):
		_save()
	
	if Input.is_action_just_pressed("interact"):
		if _interacting_object:
			if _interacting_object is Lootable:
				var _lootbox: Lootable = _interacting_object as Lootable
				interacted_with_lootable.emit(self, _lootbox)
			if _interacting_object is ExtractionMap:
				pass
				#TODO Interact with Map

	if Input.is_action_just_pressed("inventory"):
		inventory_toggled.emit(self)

	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://interface/MainMenu/main_menu.tscn")

func _update_sprites() -> void:	
	if get_global_mouse_position().x < position.x:
		player_sprite.flip_h = true
		weapon_component.weapon_sprite.scale.y = Globals.negative_weapon_component_scale
	else:
		player_sprite.flip_h = false
		weapon_component.weapon_sprite.scale.y = Globals.positive_weapon_component_scale
		
	weapon_component.weapon_sprite.look_at(get_global_mouse_position())


func _start_interacting(body: Node) -> void:
	if body != self and body is Interactable:
		_interacting_object = body


func _stop_interacting(_body: Node) -> void:
	_interacting_object = null


func equip_weapon(weapon: InventoryItemWeapon) -> void:
	weapon_component.equip_weapon(weapon)
	ui_changed.emit()


func unequip_weapon() -> void:
	weapon_component.unequip_weapon()
	ui_changed.emit()


func change_ammo(ammo: InventoryItemAmmo) -> void:
	add_item_to_inventory(weapon_component.change_ammo(ammo))


func _on_weapon_reloaded(ammo: Ammunition, magazine_capacity: int) -> void:
	var reload_ammo_amount: int = inventory_component.remove_ammo(ammo, magazine_capacity)
	weapon_component.magazine_count += reload_ammo_amount
	ui_changed.emit()


func add_item_to_inventory(item: InventoryItem) -> void:
	inventory_component._add_to_inventory(item)


func remove_item_from_inventory(item: InventoryItem) -> void:
	inventory_component._remove_from_inventory(item)


func use_consumable(item: InventoryItemConsumable) -> void:
	if item.item_type == Globals.Item_Type.HEALTH:
		var _item: Consumable = load(item.item_path) as Consumable
		health_component.heal(_item.restoration_amount)
		inventory_component._remove_from_inventory(item)
		ui_changed.emit()


func _on_hunger_timer_timeout() -> void:
	if _in_raid:
		_hunger -= 1
		ui_changed.emit()
	hunger_timer.start()


func _on_thirst_timer_timeout() -> void:
	if _in_raid:
		_thirst -= 1
		ui_changed.emit()
	thirst_timer.start()
	
	
func _save() -> void:
	var save_path: String = "user://inventory.save"
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		for item: InventoryItem in inventory_component.inventory:
			if item.item_type == Globals.Item_Type.WEAPON:
				var save_item: InventoryItemWeapon = item as InventoryItemWeapon
				file.store_line(JSON.stringify((save_item.to_dictionary())))

			if item.item_type == Globals.Item_Type.HEALTH:
				var save_item: InventoryItemConsumable = item as InventoryItemConsumable
				file.store_line(JSON.stringify((save_item.to_dictionary())))
				
			if item.item_type == Globals.Item_Type.AMMO:
				var save_item: InventoryItemAmmo = item as InventoryItemAmmo
				file.store_line(JSON.stringify((save_item.to_dictionary())))
				
			if item.item_type == Globals.Item_Type.CRAFTING_MATERIAL:
				var save_item: InventoryItemCraftingMaterial = item as InventoryItemCraftingMaterial
				file.store_line(JSON.stringify((save_item.to_dictionary())))

		if weapon_component._weapon_inventory_item:
			var save_item: InventoryItemWeapon = weapon_component._weapon_inventory_item as InventoryItemWeapon
			file.store_line(JSON.stringify((save_item.to_dictionary())))
		file.close()

	
func _load_character_data() -> void:
	inventory_component.inventory.clear()

	var save_path: String = "user://inventory.save"
	var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)

	if file:
		while file.get_position() < file.get_length():
			var content: String = file.get_line()
			var item_data: Variant = JSON.parse_string(content)
			if item_data["item_type"] == Globals.Item_Type.WEAPON:
				var _item_instance: InventoryItemWeapon = InventoryItemWeapon.new()
				_item_instance.from_dictionary(item_data)
				inventory_component._add_to_inventory(_item_instance)

				if item_data["equipped"]:
					weapon_component.equip_weapon(_item_instance)
					ui_changed.emit()

			if item_data["item_type"] == Globals.Item_Type.HEALTH:
				var _item_instance: InventoryItemConsumable = InventoryItemConsumable.new()
				_item_instance.from_dictionary(item_data)
				inventory_component._add_to_inventory(_item_instance)
				
			if item_data["item_type"] == Globals.Item_Type.AMMO:
				var _item_instance: InventoryItemAmmo = InventoryItemAmmo.new()
				_item_instance.from_dictionary(item_data)
				inventory_component._add_to_inventory(_item_instance)
				
			if item_data["item_type"] == Globals.Item_Type.CRAFTING_MATERIAL:
				var _item_instance: InventoryItemCraftingMaterial = InventoryItemCraftingMaterial.new()
				_item_instance.from_dictionary(item_data)
				inventory_component._add_to_inventory(_item_instance)


func _player_death() -> void:
	call_deferred("_return_to_hideout")


func _return_to_hideout() -> void:
	get_tree().change_scene_to_packed(load("res://levels/hideout/hideout.tscn"))
