class_name InventoryUI
extends Control

signal weapon_equipped(item: InventoryItemWeapon)
signal weapon_unequipped()
signal inventory_changed()
signal ui_opened()
signal ui_closed()


var _is_menu_open: bool = false

@onready var container: VBoxContainer = $CanvasLayer/Inventory
@onready var canvas: CanvasLayer = $CanvasLayer
@onready var equipped_weapon: InventoryUIButton = $CanvasLayer/EquippedGear/EquippedWeapon

@onready var player_sprite: Sprite2D = $CanvasLayer/Player/PlayerSprite
@onready var weapon_sprite: Sprite2D = $CanvasLayer/Player/PlayerSprite/WeaponSprite

func _ready():
	_setup_signals()


func _toggle_inventory_menu(player: Player):
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



func open_inventory(_player: Player):
	_player.player_sprite.texture = _player.player_sprite.texture
	
	if _player.weapon_component.weapon:
		weapon_sprite.texture = _player.weapon_component.weapon_sprite.texture
	else:
		weapon_sprite.texture = null
		

	var label = Label.new()
	label.text = "Inventory"
	container.add_child(label)
	for item in _player.inventory_component.inventory:
		var button = InventoryUIButton.new()
		button.text = item.item_name
		button.item = item
		container.add_child(button)
		button.connect("item_selected", _use_item)

	if _player.weapon_component.weapon:
		equipped_weapon.item = _player.weapon_component._inventory_item
		equipped_weapon.text = _player.weapon_component._inventory_item.item_name
		equipped_weapon.show()
	else:
		equipped_weapon.hide()


func close_inventory():
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()


func show_window():
	canvas.show()


func hide_window():
	canvas.hide()


func _use_item(item: InventoryItem):
	match item.item_type:
		Globals.Item_Type.WEAPON:
			if equipped_weapon.item:
				_unequip_item(equipped_weapon.item)
			var weapon: InventoryItemWeapon = item as InventoryItemWeapon
			weapon_equipped.emit(weapon)
			_reload_inventory()

func _unequip_item(item: InventoryItem):
	match item.item_type:
		Globals.Item_Type.WEAPON:
			weapon_unequipped.emit()
			equipped_weapon.item = null
			_reload_inventory()


func _reload_inventory():
	close_inventory()
	inventory_changed.emit()


func _setup_signals():
	equipped_weapon.connect("item_selected", _unequip_item)
