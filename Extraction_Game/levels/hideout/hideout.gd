class_name Hideout
extends Level

var selected_raid : String = "res://levels/forest/forest.tscn"

@onready var stash: Lootable = $Objects/Stash

func _ready():
	super._ready()
	_player._in_raid = false
	_load_stash_data()
	audio_listener.make_current()
	_connect_signals()


func _process(_delta):
	pass

func _connect_signals() -> void:
	super._connect_signals()


func _load_scene() -> void:
	if _player.weapon_component.weapon:
		_player.unequip_weapon()
	_player._save()
	_save_stash_data()
	get_tree().change_scene_to_packed(load(selected_raid))

func _on_area_2d_body_entered(_body):
	call_deferred("_load_scene")

	
func _save_stash_data() -> void:
	var save_path = "user://stash.save"
	var file = FileAccess.open(save_path, FileAccess.WRITE)

	if file:
		for item in stash.inventory_component.inventory:
			if item.item_type == Globals.Item_Type.WEAPON:
				var save_item = item as InventoryItemWeapon
				file.store_line(JSON.stringify((save_item.to_dictionary())))
		file.close()

	
func _load_stash_data():
	stash.inventory_component.inventory.clear()

	var save_path = "user://stash.save"
	var file = FileAccess.open(save_path, FileAccess.READ)

	if file:
		while file.get_position() < file.get_length():
			var content = file.get_line()
			var item_data = JSON.parse_string(content)
			var _item_instance = null
			if item_data["item_type"] == Globals.Item_Type.WEAPON:
				_item_instance = InventoryItemWeapon.new()
				_item_instance.from_dictionary(item_data)
				stash.inventory_component._add_to_inventory(_item_instance)
	else:
		print("File not found")
