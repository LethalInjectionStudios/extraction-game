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

func _ready() -> void:
	_hunger = MAX_HUNGER
	_thirst = MAX_THIRST
	
	ui_changed.emit()
	_load_character_data()

	_connect_signals()


func _process(_delta) -> void:
	_update_sprites()
	_get_input()
	z_index = position.y as int


func _physics_process(_delta) -> void:
	if !menu_open:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = direction * _move_speed
	move_and_slide()


func get_faction() -> Globals.Faction:
	return _faction


func _connect_signals() -> void:
	weapon_component.connect("weapon_added_to_inventory", inventory_component._add_to_inventory)
	weapon_component.connect("weapon_removed_from_inventory", inventory_component._remove_from_inventory)
	hitbox_component.connect("hit_taken", health_component.damage)
	hitbox_component.connect("zombie_hit_taken", health_component.zombie_damage)
	health_component.connect("damage_taken", ui.update_display)
	health_component.connect("destroyed", _player_death)
	interaction_component.connect("actor_entered", _start_interacting)
	interaction_component.connect("actor_left", _stop_interacting)


func _get_input() -> void:

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

	if Input.is_action_just_pressed("inventory"):
		inventory_toggled.emit(self)


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


func add_item_to_inventory(item: InventoryItem) -> void:
	inventory_component._add_to_inventory(item)


func remove_item_from_inventory(item: InventoryItem) -> void:
	inventory_component._remove_from_inventory(item)


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
	print("save")
	var save_path: String = "user://inventory.save"
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	print(file)
	if file:
		for item: InventoryItem in inventory_component.inventory:
			if item.item_type == Globals.Item_Type.WEAPON:
				var save_item: InventoryItemWeapon = item as InventoryItemWeapon
				print(JSON.stringify(save_item.to_dictionary()))
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


func _player_death() -> void:
	get_tree().change_scene_to_packed(load("res://levels/hideout.tscn"))
