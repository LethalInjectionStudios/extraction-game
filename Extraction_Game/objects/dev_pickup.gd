class_name DevItemPickup
extends Node2D

var item: InventoryItemWeapon = InventoryItemWeapon.new()
var texture: = "res://sprites/weapon_components/pistol_suppressor.png"

func _ready():
	item.weapon_resource_path = "res://resources/weapons/ar.tres"
	item.item_type = Globals.Item_Type.WEAPON
	item.muzzle = "res://sprites/weapon_components/pistol_suppressor.png"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body is Player:
		var player = body as Player
		player.inventory_component._add_to_inventory(item)
		queue_free()
