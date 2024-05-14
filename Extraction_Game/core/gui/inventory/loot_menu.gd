class_name LootMenu
extends Control

signal ui_opened()
signal ui_closed()
signal lootbox_changed()
signal item_moved_player_to_lootbox(lootbox: String, item: InventoryItem)
signal item_moved_lootbox_to_player(lootbox: String, item: InventoryItem)

var _is_menu_open: bool = false
var _lootbox: String

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


func _ready() -> void:
	_setup_signals()


func _toggle_loot_menu(player: Player, lootbox: Lootable) -> void:

	if !_is_menu_open:
		_lootbox = lootbox.get_path()
		ui_opened.emit()
		_is_menu_open = true
		canvas.show()
		_open_menu(player, lootbox)
	else:
		ui_closed.emit()
		_is_menu_open = false
		canvas.hide()
		_close_menu()


func _setup_signals() -> void:
	#_equipped_weapon.connect("item_selected", _unequip_item)
	_equipped_weapon.item_hovered.connect(_item_description.Show)
	_equipped_weapon.item_hover_ended.connect(_item_description.Hide)
	#_equipped_armor.item_selected.connect(_unequip_item)
	_equipped_armor.item_hovered.connect(_item_description.Show)
	_equipped_armor.item_hover_ended.connect(_item_description.Hide)


func _open_menu(player: Player, lootbox: Lootable) -> void:	
	
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

		button.connect("item_selected", _on_move_item_player_to_lootbox)
		button.item_hovered.connect(_item_description.Show)
		button.item_hover_ended.connect(_item_description.Hide)
		player_container.add_child(button)


	for item: InventoryItem in lootbox.inventory_component.inventory:
		var button: InventoryUIButton = INVENTORY_BUTTON.instantiate()
		button.icon = load(item.item_icon)
		button.item = item

		if item is InventoryItemAmmo:
			button.quantity.text = str(item.quantity)
			
		button.connect("item_selected", _on_move_item_lootbox_to_player)
		button.item_hovered.connect(_item_description.Show)
		button.item_hover_ended.connect(_item_description.Hide)
		lootbox_container.add_child(button)


func _close_menu() -> void:
	for child: Node in player_container.get_children():
		player_container.remove_child(child)
		child.queue_free()

	for child: Node in lootbox_container.get_children():
		lootbox_container.remove_child(child)
		child.queue_free()


func _reload_menu() -> void:
	_close_menu()
	lootbox_changed.emit(_lootbox)

#TODO Item clicks prompts player to move or equip item to and from lootbox
func _on_move_item_player_to_lootbox(item: InventoryItem) -> void:
	item_moved_player_to_lootbox.emit(_lootbox, item)
	_reload_menu()


func _on_move_item_lootbox_to_player(item: InventoryItem) -> void:
	item_moved_lootbox_to_player.emit(_lootbox, item)
	_reload_menu()
