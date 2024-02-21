class_name RandomLootable
extends Lootable

@export var drops: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():
	if !drops.is_empty():
		for i in range(randi_range(0,5)):
			var res = load(drops[0])
			var item = InventoryItem.new()

			item.item_name = res.name
			item.item_path = drops[0]

			inventory_component._add_to_inventory(item)
