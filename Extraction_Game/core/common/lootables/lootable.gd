class_name Lootable
extends Interactable

@onready var inventory_component: InventoryComponent = $Components/InventoryComponent
#@export var _sprite: Sprite2D

## if [code]true[/code] Sorting tabs will be shown on the loot menu
@export var is_sortable: bool
@export var box_name: String

func _ready() -> void:
	interactable_type = Globals.Interactable_Type.LOOTABLE
	z_index = position.y as int
