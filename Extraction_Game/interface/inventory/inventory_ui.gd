class_name InventoryUI
extends Control

signal equip_weapon(item: InventoryItemWeapon)
signal unequip_weapon()

@onready var parent: Player = get_parent()
@onready var player_sprite: Sprite2D = $CanvasLayer/Control/PlayerSprite
@onready var container: VBoxContainer = $CanvasLayer/Inventory
@onready var canvas: CanvasLayer = $CanvasLayer
@onready var equipped_weapon: InventoryUIButton = $CanvasLayer/EquippedGear/EquippedWeapon


func _ready():
	_setup_signals()


func open_inventory():
	player_sprite.texture = parent.player_sprite.texture

	var label = Label.new()
	label.text = "Inventory"
	container.add_child(label)
	for item in parent.inventory_component.inventory.inventory:
		var button = InventoryUIButton.new()
		button.text = item.item_name
		button.item = item
		container.add_child(button)
		button.connect("item_selected", _use_item)

	if parent.weapon_component.weapon:
		equipped_weapon.item = parent.weapon_component._inventory_item
		equipped_weapon.text = parent.weapon_component._inventory_item.item_name
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
			equip_weapon.emit(weapon)
			parent.inventory_component._remove_from_inventory(item)
			_reload_inventory()

func _unequip_item(item: InventoryItem):
	match item.item_type:
		Globals.Item_Type.WEAPON:
			unequip_weapon.emit()
			parent.inventory_component._add_to_inventory(item)
			equipped_weapon.item = null
			_reload_inventory()


func _reload_inventory():
	close_inventory()
	open_inventory()


func _setup_signals():
	equipped_weapon.connect("item_selected", _unequip_item)