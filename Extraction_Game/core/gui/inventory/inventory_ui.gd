class_name InventoryUI
extends Control

signal weapon_equipped(item: InventoryItemWeapon)
signal weapon_unequipped()
signal weapon_ammo_changed(ammo: InventoryItemAmmo)
signal armor_equipped(item: InventoryItemArmor)
signal armor_unequipped()
signal inventory_changed()
signal ui_opened()
signal ui_closed()
signal consumable_used(item: InventoryItemConsumable)


var _is_menu_open: bool = false
var player: Player

@onready var container: GridContainer = $CanvasLayer/Background/ScrollContainer/Inventory
@onready var canvas: CanvasLayer = $CanvasLayer
@onready var equipped_weapon: InventoryUIButton = $CanvasLayer/Background/EquippedWeaponButton
@export var equipped_armor: InventoryUIButton
@onready var loaded_ammo: Button = $CanvasLayer/Background/LoadedAmmo

@onready var player_sprite: Sprite2D = $CanvasLayer/Background/Player/PlayerSprite
@onready var weapon_sprite: Sprite2D = $CanvasLayer/Background/Player/PlayerSprite/WeaponSprite
@onready var item_description: ItemDescription = $CanvasLayer/Background/ItemDescription

@onready var _health_bar: ProgressBar = $CanvasLayer/Background/Health/ProgressBar
@onready var _hunger_bar: ProgressBar = $CanvasLayer/Background/Hunger/ProgressBar
@onready var _thirst_bar: ProgressBar = $CanvasLayer/Background/Thirst/ProgressBar

@onready var armor_durability: ProgressBar = $CanvasLayer/Background/EquippedArmorButton/ArmorDurability
@onready var weapon_durability: ProgressBar = $CanvasLayer/Background/EquippedWeaponButton/WeaponDurability

const INVENTORY_BUTTON: PackedScene = preload("res://core/gui/inventory/inventory_button.tscn")
const AMMO_SWAP_BUTTON: PackedScene = preload("res://core/components/inventory_component/ammo_swap_button.tscn")

func _ready() -> void:
	_setup_signals()	


func _toggle_inventory_menu(_player: Player) -> void:
	if !_is_menu_open:
		ui_opened.emit()
		_is_menu_open = true
		open_inventory(_player)
		show_window()
	else:
		ui_closed.emit()
		_is_menu_open = false
		hide_window()
		close_inventory()



func open_inventory(_player: Player) -> void:
	_player.player_sprite.texture = _player.player_sprite.texture
	player = _player
	
	if _player.weapon_component.weapon:
		weapon_sprite.texture = _player.weapon_component.weapon_sprite.texture
	else:
		weapon_sprite.texture = null
		
	for item: InventoryItem in _player.inventory_component.inventory:		
		var button: InventoryUIButton = INVENTORY_BUTTON.instantiate()
		button.icon = load(item.item_icon)
		button.item = item

		if item is InventoryItemAmmo or item is InventoryItemCraftingMaterial:
			button.quantity.text = str(item.quantity)

		container.add_child(button)
		button.connect("item_selected", _use_item)
		button.item_hovered.connect(item_description.Show)
		button.item_hover_ended.connect(item_description.Hide)

	if _player.weapon_component.weapon:
		equipped_weapon.item = _player.weapon_component._weapon_inventory_item
		equipped_weapon.icon = load(equipped_weapon.item.item_icon)
		if !equipped_weapon.item.ammo_type.is_empty():
			var loaded_ammo_data: Ammunition = load(equipped_weapon.item.ammo_type)
			loaded_ammo.icon = load(loaded_ammo_data.sprite)
			equipped_weapon.show()
		weapon_durability.value = equipped_weapon.item.durability
		loaded_ammo.show()
	else:
		equipped_weapon.hide()
		loaded_ammo.hide()
		
	if _player.armor_component.armor:
		equipped_armor.item = _player.armor_component._armor_inventory_item
		equipped_armor.icon = load(equipped_armor.item.item_icon)
		armor_durability.value = equipped_armor.item.durability
		equipped_armor.show()
	else:
		equipped_armor.hide()
		
	_health_bar.value = player.health_component.get_health()
	_hunger_bar.value = player._hunger
	_thirst_bar.value = player._thirst


func close_inventory() -> void:
	for child: Node in container.get_children():
		container.remove_child(child)
		child.queue_free()

	var options: Array[Node] = loaded_ammo.get_children()
	for child: Node in options:
		child.queue_free()

	player = null


func show_window() -> void:
	canvas.show()


func hide_window() -> void:
	canvas.hide()


func _setup_signals() -> void:
	equipped_weapon.connect("item_selected", _unequip_item)
	equipped_weapon.item_hovered.connect(item_description.Show)
	equipped_weapon.item_hover_ended.connect(item_description.Hide)
	equipped_armor.item_selected.connect(_unequip_item)
	equipped_armor.item_hovered.connect(item_description.Show)
	equipped_armor.item_hover_ended.connect(item_description.Hide)
	loaded_ammo.connect("pressed", _on_loaded_ammo_pressed)


func _use_item(item: InventoryItem) -> void:
	match item.item_type:
		Globals.Item_Type.WEAPON:
			if equipped_weapon.item:
				_unequip_item(equipped_weapon.item)
			var weapon: InventoryItemWeapon = item as InventoryItemWeapon
			weapon_equipped.emit(weapon)
			
		Globals.Item_Type.ARMOR:
			if equipped_armor.item:
				_unequip_item(equipped_armor.item)
			var armor: InventoryItemArmor = item as InventoryItemArmor
			armor_equipped.emit(armor)
				
		Globals.Item_Type.CONSUMABLE:
			var consumable: InventoryItemConsumable = item as InventoryItemConsumable
			consumable_used.emit(consumable)
	_reload_inventory()
	
func _on_loaded_ammo_pressed() -> void:
	if loaded_ammo.get_child_count() > 0:
		return
		
	var ammo_options: VBoxContainer = VBoxContainer.new()
	loaded_ammo.add_child(ammo_options)
	ammo_options.position.y += 55

	for item: InventoryItem in player.inventory_component.inventory:
		if item is InventoryItemAmmo:
			var ammo: Ammunition = load(item.item_path)
			var weapon: Weapon = load(equipped_weapon.item.item_path)
			if ammo.caliber == weapon.caliber and item.item_name != player.weapon_component._ammo_inventory_item.item_name:
				var button: AmmoSwapButton = AMMO_SWAP_BUTTON.instantiate()
				button.text = item.item_name
				button.item = InventoryItemAmmo.new()
				
				button.item.item_name = item.item_name
				button.item.item_type = item.item_type
				button.item.item_icon = item.item_icon
				button.item.item_path = item.item_path	
				
				
				ammo_options.add_child(button)
				button.connect("item_selected", _on_ammo_type_changed)


func _on_ammo_type_changed(item: InventoryItemAmmo) -> void:
	weapon_ammo_changed.emit(item)
	loaded_ammo.icon = load(item.item_icon)
	var options: Array[Node] = loaded_ammo.get_children()
	for child: Node in options:
		child.queue_free()

	_reload_inventory()


func _unequip_item(item: InventoryItem) -> void:
	match item.item_type:
		Globals.Item_Type.WEAPON:
			weapon_unequipped.emit()
			equipped_weapon.item = null
		Globals.Item_Type.ARMOR:
			armor_unequipped.emit()
			equipped_armor.item = null
	_reload_inventory()
			


func _reload_inventory() -> void:
	close_inventory()
	inventory_changed.emit()
