class_name DevItemPickup
extends Node2D

var item: InventoryItemWeapon = InventoryItemWeapon.new()

func _ready():
	item.weapon_resource_path = "res://resources/weapons/ar.tres"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body is Player:
		var player = body as Player
		player.inventory_component._add_to_inventory(item)
