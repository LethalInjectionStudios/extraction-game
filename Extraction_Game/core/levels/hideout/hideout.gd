class_name Hideout
extends Level

var selected_raid : String = "res://core/levels/loading/loading_scene.tscn"

@onready var stash: Lootable = $Objects/Stash

func _ready() -> void:
	super._ready()
	_player._in_raid = false
	_load_stash_data()
	audio_listener.make_current()
	_connect_signals()


func _process(_delta: float) -> void:
	audio_listener.global_position = _player.global_position

func _connect_signals() -> void:
	super._connect_signals()


func _load_scene() -> void:
	_player._save()
	_save_stash_data()
	System.log(selected_raid)
	get_tree().change_scene_to_packed(load(selected_raid))

func _on_area_2d_body_entered(_body: Node2D) -> void:
	call_deferred("_load_scene")

#region Stash Save/Load
func _save_stash_data() -> void:
	var save_path: String = "user://stash.save"
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)

	if file:
		for item: InventoryItem in stash.inventory_component.inventory:
			if item.item_type == Globals.Item_Type.WEAPON:
				var save_item: InventoryItemWeapon = item as InventoryItemWeapon
				file.store_line(JSON.stringify((save_item.to_dictionary())))
				
			if item.item_type == Globals.Item_Type.ARMOR:
				var save_item: InventoryItemArmor = item as InventoryItemArmor
				file.store_line(JSON.stringify((save_item.to_dictionary())))
				
			if item.item_type == Globals.Item_Type.CONSUMABLE:
				var save_item: InventoryItemConsumable = item as InventoryItemConsumable
				file.store_line(JSON.stringify((save_item.to_dictionary())))
				
			if item.item_type == Globals.Item_Type.AMMO:
				var save_item: InventoryItemAmmo = item as InventoryItemAmmo
				file.store_line(JSON.stringify((save_item.to_dictionary())))
		file.close()

	
func _load_stash_data() -> void:
	stash.inventory_component.inventory.clear()

	var save_path: String = "user://stash.save"
	var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)

	if file:
		while file.get_position() < file.get_length():
			var content: String = file.get_line()
			var item_data: Variant = JSON.parse_string(content)
			if item_data["item_type"] == Globals.Item_Type.WEAPON:
				var _item_instance: InventoryItemWeapon = InventoryItemWeapon.new()
				_item_instance.from_dictionary(item_data)
				stash.inventory_component._add_to_inventory(_item_instance)
				
			if item_data["item_type"] == Globals.Item_Type.ARMOR:
				var _item_instance: InventoryItemArmor = InventoryItemArmor.new()
				_item_instance.from_dictionary(item_data)
				stash.inventory_component._add_to_inventory(_item_instance)
				
			if item_data["item_type"] == Globals.Item_Type.CONSUMABLE:
				var _item_instance: InventoryItemConsumable = InventoryItemConsumable.new()
				_item_instance.from_dictionary(item_data)
				stash.inventory_component._add_to_inventory(_item_instance)
				
			if item_data["item_type"] == Globals.Item_Type.AMMO:
				var _item_instance: InventoryItemAmmo = InventoryItemAmmo.new()
				_item_instance.from_dictionary(item_data)
				stash.inventory_component._add_to_inventory(_item_instance)
			
	else:
		push_warning("Save File not Found")
#endregion
