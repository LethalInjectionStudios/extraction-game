class_name LootMenu
extends Control

signal ui_opened()
signal ui_closed()
signal lootbox_changed()
signal item_moved_player_to_lootbox(lootbox: String, item: InventoryItem)
signal item_moved_lootbox_to_player(lootbox: String, item: InventoryItem)
signal weapon_equipped(item: InventoryItemWeapon)
signal weapon_unequipped()
signal armor_equipped(item: InventoryItemArmor)
signal armor_unequipped()

var _is_menu_open: bool = false
var _lootbox: String
var _lootbox_inventory: InventoryComponent
var _player_inventory: InventoryComponent
var _focused_item: InventoryItem

const INVENTORY_BUTTON: PackedScene = preload("res://core/gui/inventory/inventory_button.tscn")

@onready var canvas: CanvasLayer = $CanvasLayer
@onready var _item_description: ItemDescription = $CanvasLayer/Background/ItemDescription

@onready var player_container: GridContainer = $CanvasLayer/Background/ScrollContainer/PlayerInventory
@onready var lootbox_container: GridContainer = $CanvasLayer/Background/ScrollContainer2/LootInventory

@onready var _weapon_sprite: Sprite2D = $CanvasLayer/Background/Player/PlayerSprite/WeaponSprite
@onready var _equipped_weapon: InventoryUIButton = $CanvasLayer/Background/EquippedWeaponButton
@onready var _weapon_durability: ProgressBar = $CanvasLayer/Background/EquippedWeaponButton/WeaponDurability
@onready var _equipped_armor: InventoryUIButton = $CanvasLayer/Background/EquippedArmorButton
@onready var _armor_durability: ProgressBar = $CanvasLayer/Background/EquippedArmorButton/ArmorDurability

@onready var _loot_options: VBoxContainer = $CanvasLayer/Background/LootOptions
@onready var _loot_move: Button = $CanvasLayer/Background/LootOptions/Move
@onready var _loot_equip: Button = $CanvasLayer/Background/LootOptions/Equip

@onready var _player_options: VBoxContainer = $CanvasLayer/Background/PlayerOptions
@onready var _player_move: Button = $CanvasLayer/Background/PlayerOptions/Move
@onready var _player_equip: Button = $CanvasLayer/Background/PlayerOptions/Equip

@onready var _sort_options: HBoxContainer = $CanvasLayer/Background/SortOptions


func _ready() -> void:
	_setup_signals()


func _toggle_loot_menu(player: Player, lootbox: Lootable) -> void:

	if !_is_menu_open:
		_lootbox = lootbox.get_path()
		ui_opened.emit()
		_is_menu_open = true
		
		if lootbox.is_sortable:
			_sort_options.visible = true
		else:
			_sort_options.visible = false
			
		canvas.show()
		_open_menu(player, lootbox)
	else:
		ui_closed.emit()
		_is_menu_open = false
		canvas.hide()
		_close_menu()


func _setup_signals() -> void:
	_equipped_weapon.item_selected.connect(_unequip_item)
	_equipped_weapon.item_hovered.connect(_on_item_hover_enter)
	_equipped_weapon.item_hover_ended.connect(_on_item_hover_exit)
	_equipped_armor.item_selected.connect(_unequip_item)
	_equipped_armor.item_hovered.connect(_on_item_hover_enter)
	_equipped_armor.item_hover_ended.connect(_on_item_hover_exit)
	
	_loot_move.button_down.connect(_on_move_item_lootbox_to_player)
	_loot_equip.button_down.connect(_on_equip_from_lootbox)
	
	_player_move.button_down.connect(_on_move_item_player_to_lootbox)
	_player_equip.button_down.connect(_on_equip_from_inventory)


func _open_menu(player: Player, lootbox: Lootable) -> void:	
	_lootbox_inventory = lootbox.inventory_component
	_player_inventory = player.inventory_component
	
	if player.weapon_component.weapon:
		_weapon_sprite.texture = player.weapon_component.weapon_sprite.texture
		_equipped_weapon.item = player.weapon_component._weapon_inventory_item
		_equipped_weapon.icon = load(_equipped_weapon.item.item_icon)
		_equipped_weapon.show()
		_weapon_durability.value = _equipped_weapon.item.durability
	else:
		_equipped_weapon.hide()
		_weapon_sprite.texture = null
		
	if player.armor_component.armor:
		_equipped_armor.item = player.armor_component._armor_inventory_item
		_equipped_armor.icon = load(_equipped_armor.item.item_icon)
		_armor_durability.value = _equipped_armor.item.durability
		_equipped_armor.show()
	else:
		_equipped_armor.hide()
	
		
	for item: InventoryItem in player.inventory_component.inventory:
		var button: InventoryUIButton = INVENTORY_BUTTON.instantiate()
		button.icon = load(item.item_icon)
		button.item = item

		if item is InventoryItemAmmo:
			button.quantity.text = str(item.quantity)

		button.connect("item_selected", _on_inventory_item_pressed)
		button.item_hovered.connect(_on_item_hover_enter)
		button.item_hover_ended.connect(_on_item_hover_exit)
		player_container.add_child(button)


	for item: InventoryItem in lootbox.inventory_component.inventory:
		var button: InventoryUIButton = INVENTORY_BUTTON.instantiate()
		button.icon = load(item.item_icon)
		button.item = item

		if item is InventoryItemAmmo:
			button.quantity.text = str(item.quantity)
			
		button.connect("item_selected", _on_lootbox_item_pressed)
		button.item_hovered.connect(_on_item_hover_enter)
		button.item_hover_ended.connect(_on_item_hover_exit)
		lootbox_container.add_child(button)


func _close_menu() -> void:
	for child: Node in player_container.get_children():
		player_container.remove_child(child)
		child.queue_free()

	for child: Node in lootbox_container.get_children():
		lootbox_container.remove_child(child)
		child.queue_free()


func _unequip_item(item: InventoryItem) -> void:
	match item.item_type:
		Globals.Item_Type.WEAPON:
			weapon_unequipped.emit()
			_equipped_weapon.item = null
		Globals.Item_Type.ARMOR:
			armor_unequipped.emit()
			_equipped_armor.item = null
	_reload_menu()
			

func _reload_menu() -> void:
	_close_menu()
	lootbox_changed.emit(_lootbox)


func _on_item_hover_enter(item: InventoryItem) -> void:
	_loot_options.visible = false
	_player_options.visible = false
	_focused_item = null
	_item_description.Show(item)

	
func _on_item_hover_exit() -> void:
	_item_description.Hide()
	
	
#region Lootbox to Player
func _on_lootbox_item_pressed(item: InventoryItem) -> void:
	if Input.is_key_label_pressed(KEY_CTRL):
			item_moved_lootbox_to_player.emit(_lootbox, item)
			_reload_menu()
			return
			
	var _data: Item = load(item.item_path) as Item
	if _data.is_equipable:
		_loot_equip.visible = true
	else:
		_loot_equip.visible = false
				
	var _item_index: int = _lootbox_inventory.inventory.find(item)
	var _button: InventoryUIButton = lootbox_container.get_child(_item_index)
	_focused_item = item
	
	_loot_options.global_position = _button.global_position + Vector2(10, 80)
	_loot_options.visible = true
	_item_description.visible = false


func _on_move_item_lootbox_to_player() -> void:
	item_moved_lootbox_to_player.emit(_lootbox, _focused_item)
	_reload_menu()
	
	_loot_options.visible = false
	_focused_item = null

	
func _on_equip_from_lootbox() -> void:
	if _focused_item.item_type == Globals.Item_Type.WEAPON:
		var weapon: InventoryItemWeapon = _focused_item as InventoryItemWeapon
		weapon_equipped.emit(weapon)
		_lootbox_inventory._remove_from_inventory(weapon)
	elif _focused_item.item_type == Globals.Item_Type.ARMOR:
		var armor: InventoryItemArmor = _focused_item as InventoryItemArmor
		armor_equipped.emit(armor)
		_lootbox_inventory._remove_from_inventory(armor)

	_reload_menu()
#endregion

#region Player to Lootbox
func _on_inventory_item_pressed(item: InventoryItem) -> void:
	if Input.is_key_label_pressed(KEY_CTRL):
		item_moved_player_to_lootbox.emit(_lootbox, item)
		_reload_menu()
		return
			
	var _data: Item = load(item.item_path) as Item
	if _data.is_equipable:
		_player_equip.visible = true
	else:
		_player_equip.visible = false
				
	var _item_index: int = _player_inventory.inventory.find(item)
	var _button: InventoryUIButton = player_container.get_child(_item_index)
	_focused_item = item
	
	_player_options.global_position = _button.global_position + Vector2(10, 80)
	_player_options.visible = true
	_item_description.visible = false

	
func _on_move_item_player_to_lootbox() -> void:
	item_moved_player_to_lootbox.emit(_lootbox, _focused_item)
	_reload_menu()
	
	_loot_options.visible = false
	_focused_item = null
	

func _on_equip_from_inventory() -> void:
	if _focused_item.item_type == Globals.Item_Type.WEAPON:
		var weapon: InventoryItemWeapon = _focused_item as InventoryItemWeapon
		weapon_equipped.emit(weapon)
	elif _focused_item.item_type == Globals.Item_Type.ARMOR:
		var armor: InventoryItemArmor = _focused_item as InventoryItemArmor
		armor_equipped.emit(armor)

	_reload_menu()
#endregion
