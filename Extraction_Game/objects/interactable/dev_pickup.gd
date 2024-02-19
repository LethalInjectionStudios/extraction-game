class_name DevItemPickup
extends Node2D

var item: InventoryItemWeapon = InventoryItemWeapon.new()

func _ready():
	item.item_name = "Pistol"
	item.item_type = Globals.Item_Type.WEAPON
	item.item_path = "res://resources/weapons/dev_gun.tres"
	item.item_icon = "res://sprites/weapons/gun.png"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body is Player:
		var player = body as Player
		player.inventory_component._add_to_inventory(item)
		queue_free()