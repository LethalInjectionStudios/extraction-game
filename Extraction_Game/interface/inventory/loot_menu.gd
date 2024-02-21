class_name LootMenu
extends Control

signal ui_opened()
signal ui_closed()
signal lootbox_changed()
signal item_moved_player_to_lootbox(lootbox: String, item: InventoryItem)
signal item_moved_lootbox_to_player(lootbox: String, item: InventoryItem)

var _is_menu_open: bool = false
var _lootbox: String

@onready var canvas: CanvasLayer = $CanvasLayer
@onready var player_container: VBoxContainer = $CanvasLayer/PlayerInventory
@onready var lootbox_container: VBoxContainer = $CanvasLayer/LootInventory

func _ready():
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
	pass


func _open_menu(player: Player, lootbox: Lootable) -> void:
	var player_label = Label.new()
	player_label.text = "Inventory"
	player_container.add_child(player_label)
	for item in player.inventory_component.inventory:
		var button = InventoryUIButton.new()
		button.text = item.item_name
		button.item = item
		button.connect("item_selected", _on_move_item_player_to_lootbox)
		player_container.add_child(button)


	var lootbox_label = Label.new()
	lootbox_label.text = "Loot Box"
	lootbox_container.add_child(lootbox_label)
	for item in lootbox.inventory_component.inventory:
		var button = InventoryUIButton.new()
		button.text = item.item_name
		button.item = item
		button.connect("item_selected", _on_move_item_lootbox_to_player)
		lootbox_container.add_child(button)


func _close_menu() -> void:
	for child in player_container.get_children():
		player_container.remove_child(child)
		child.queue_free()

	for child in lootbox_container.get_children():
		lootbox_container.remove_child(child)
		child.queue_free()


func _reload_menu() -> void:
	_close_menu()
	lootbox_changed.emit(_lootbox)


func _on_move_item_player_to_lootbox(item: InventoryItem):
	item_moved_player_to_lootbox.emit(_lootbox, item)
	_reload_menu()


func _on_move_item_lootbox_to_player(item: InventoryItem):
	item_moved_lootbox_to_player.emit(_lootbox, item)
	_reload_menu()
