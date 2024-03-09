class_name InventoryUI
extends Control

signal weapon_equipped(item: InventoryItemWeapon)
signal weapon_unequipped()
signal inventory_changed()
signal ui_opened()
signal ui_closed()
signal consumable_used(item: InventoryItemConsumable)


var _is_menu_open: bool = false

@onready var container: GridContainer = $CanvasLayer/ScrollContainer/Inventory
@onready var canvas: CanvasLayer = $CanvasLayer
@onready var equipped_weapon: InventoryUIButton = $CanvasLayer/EquippedGear/EquippedWeapon

@onready var player_sprite: Sprite2D = $CanvasLayer/Player/PlayerSprite
@onready var weapon_sprite: Sprite2D = $CanvasLayer/Player/PlayerSprite/WeaponSprite

const INVENTORY_BUTTON: PackedScene = preload("res://interface/inventory/inventory_button.tscn")

func _ready() -> void:
	_setup_signals()


func _toggle_inventory_menu(player: Player) -> void:
	if !_is_menu_open:
		ui_opened.emit()
		_is_menu_open = true
		show_window()
		open_inventory(player)
	else:
		ui_closed.emit()
		_is_menu_open = false
		hide_window()
		close_inventory()



func open_inventory(_player: Player) -> void:
	_player.player_sprite.texture = _player.player_sprite.texture
	
	if _player.weapon_component.weapon:
		weapon_sprite.texture = _player.weapon_component.weapon_sprite.texture
	else:
		weapon_sprite.texture = null
		
	for item: InventoryItem in _player.inventory_component.inventory:		
		var button: InventoryUIButton = INVENTORY_BUTTON.instantiate()
		button.item_icon.texture = load(item.item_icon) as CompressedTexture2D
		button.item = item

		if item is InventoryItemAmmo:
			button.quantity.text = str(item.quantity)

		container.add_child(button)
		button.connect("item_selected", _use_item)

	if _player.weapon_component.weapon:
		equipped_weapon.item = _player.weapon_component._inventory_item
		#equipped_weapon.text = _player.weapon_component._inventory_item.item_name
		equipped_weapon.icon = load(equipped_weapon.item.item_icon)
		print(load(equipped_weapon.item.item_icon))
		equipped_weapon.show()
	else:
		equipped_weapon.hide()


func close_inventory() -> void:
	for child: Node in container.get_children():
		container.remove_child(child)
		child.queue_free()


func show_window() -> void:
	canvas.show()


func hide_window() -> void:
	canvas.hide()


func _use_item(item: InventoryItem) -> void:
	match item.item_type:
		Globals.Item_Type.WEAPON:
			if equipped_weapon.item:
				_unequip_item(equipped_weapon.item)
			var weapon: InventoryItemWeapon = item as InventoryItemWeapon
			weapon_equipped.emit(weapon)
		Globals.Item_Type.HEALTH:
			print("Health Used")
			var health_pack: InventoryItemConsumable = item as InventoryItemConsumable
			consumable_used.emit(health_pack)
	_reload_inventory()


func _unequip_item(item: InventoryItem) -> void:
	match item.item_type:
		Globals.Item_Type.WEAPON:
			weapon_unequipped.emit()
			equipped_weapon.item = null
			_reload_inventory()


func _reload_inventory() -> void:
	close_inventory()
	inventory_changed.emit()


func _setup_signals() -> void:
	equipped_weapon.connect("item_selected", _unequip_item)
