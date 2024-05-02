class_name Level
extends Node2D

const PLAYER: PackedScene = preload("res://core/characters/player/player.tscn")

@onready var audio_listener : AudioListener2D = $AudioListener
@onready var inventory_ui: InventoryUI = $Menu/Inventory
@onready var lootbox_ui: LootMenu = $Menu/LootMenu
@onready var spawn_points: Node2D = $SpawnPoints

var _player: Player

func _ready() -> void:
	_player = PLAYER.instantiate() as Player
	add_child(_player)
	var _spawn_point: Node = spawn_points.get_child(randi() % spawn_points.get_child_count())
	_player.global_position = _spawn_point.global_position

	_player._in_raid = true


func _connect_signals() -> void:
	for weapon: Node in get_tree().get_nodes_in_group("Weapon"):
		weapon.connect("weapon_fired", _on_weapon_fired)

	_player.connect("inventory_toggled", inventory_ui._toggle_inventory_menu)
	_player.connect("interacted_with_lootable", lootbox_ui._toggle_loot_menu)
	_player.connect("ui_changed", _player.ui.update_display)

	inventory_ui.connect("weapon_equipped", _player.equip_weapon)
	inventory_ui.connect("weapon_unequipped", _player.unequip_weapon)
	inventory_ui.armor_equipped.connect(_player.equip_armor)
	inventory_ui.armor_unequipped.connect(_player.unequip_armor)
	inventory_ui.connect("weapon_ammo_changed", _player.change_ammo)
	inventory_ui.connect("inventory_changed", _on_inventory_ui_changed)
	inventory_ui.connect("ui_opened", _on_menu_opened)
	inventory_ui.connect("ui_closed", _on_menu_closed)
	inventory_ui.connect("consumable_used", _player.use_consumable)

	lootbox_ui.connect("item_moved_player_to_lootbox", _on_item_moved_player_lootbox)
	lootbox_ui.connect("item_moved_lootbox_to_player", _on_item_moved_lootbox_player)
	lootbox_ui.connect("lootbox_changed", _on_lootbox_changed)
	lootbox_ui.connect("ui_opened", _on_menu_opened)
	lootbox_ui.connect("ui_closed", _on_menu_closed)

	
	
func _on_weapon_fired(projectile: Projectile) -> void:
	for enemy: Character in get_tree().get_nodes_in_group("Enemy"):
		#if enemy.global_position.distance_to(projectile.global_position) <= projectile.sound_emmitted:
		enemy.sound_heard(projectile.global_position)
	$Projectiles.add_child(projectile)	
	

func _on_poi_created(poi: POI) -> void:
	$POI.add_child(poi)


func _on_inventory_ui_changed() -> void:
	inventory_ui.open_inventory(_player)

func _on_menu_opened() -> void:
	_player.menu_open = true


func _on_menu_closed() -> void:
	_player.menu_open = false


func _on_item_moved_player_lootbox(lootbox: String, item: InventoryItem) -> void:
	var _lootbox: Lootable = get_node(lootbox) as Lootable

	_player.remove_item_from_inventory(item)
	_lootbox.inventory_component._add_to_inventory(item)


func _on_item_moved_lootbox_player(lootbox: String, item: InventoryItem) -> void:
	var _lootbox: Lootable = get_node(lootbox) as Lootable

	_player.add_item_to_inventory(item)
	_lootbox.inventory_component._remove_from_inventory(item)


func _on_lootbox_changed(lootbox: String) -> void:
	var _lootbox: Node = get_node(lootbox)

	lootbox_ui._open_menu(_player, _lootbox)
