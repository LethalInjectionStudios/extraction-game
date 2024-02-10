class_name Level
extends Node2D

@onready var player : Player = $Player
@onready var audio_listener : AudioListener2D = $AudioListener
@onready var inventory_ui: InventoryUI = $Menu/Inventory
@onready var lootbox_ui: LootMenu = $Menu/LootMenu


func _ready():
	player._in_raid = true


func _process(_delta):
	pass


func _connect_signals() -> void:
	for weapon in get_tree().get_nodes_in_group("Weapon"):
		weapon.connect("weapon_fired", _on_weapon_fired)
		
	for poi in get_tree().get_nodes_in_group("POI"):
		poi.connect("poi_created", _on_poi_created)

	player.connect("inventory_toggled", inventory_ui._toggle_inventory_menu)
	player.connect("interacted_with_lootable", lootbox_ui._toggle_loot_menu)

	inventory_ui.connect("weapon_equipped", player.equip_weapon)
	inventory_ui.connect("weapon_unequipped", player.unequip_weapon)
	inventory_ui.connect("inventory_changed", _on_inventory_ui_changed)
	inventory_ui.connect("ui_opened", _on_menu_opened)
	inventory_ui.connect("ui_closed", _on_menu_closed)

	lootbox_ui.connect("item_moved_player_to_lootbox", _on_item_moved_player_lootbox)
	lootbox_ui.connect("item_moved_lootbox_to_player", _on_item_moved_lootbox_player)
	lootbox_ui.connect("lootbox_changed", _on_lootbox_changed)
	lootbox_ui.connect("ui_opened", _on_menu_opened)
	lootbox_ui.connect("ui_closed", _on_menu_closed)

	
	
func _on_weapon_fired(projectile) -> void:
	$Projectiles.add_child(projectile)
	

func _on_poi_created(poi) -> void:
	$POI.add_child(poi)


func _on_inventory_ui_changed() -> void:
	inventory_ui.open_inventory(player)

func _on_menu_opened() -> void:
	player.menu_open = true


func _on_menu_closed() -> void:
	player.menu_open = false


func _on_item_moved_player_lootbox(lootbox: String, item: InventoryItem) -> void:
	var _lootbox = get_node(lootbox) as Loot

	player.remove_item_from_inventory(item)
	_lootbox.inventory_component._add_to_inventory(item)


func _on_item_moved_lootbox_player(lootbox: String, item: InventoryItem) -> void:
	var _lootbox = get_node(lootbox) as Loot

	player.add_item_to_inventory(item)
	_lootbox.inventory_component._remove_from_inventory(item)


func _on_lootbox_changed(lootbox: String) -> void:
	var _lootbox = get_node(lootbox)

	lootbox_ui._open_menu(player, _lootbox)
