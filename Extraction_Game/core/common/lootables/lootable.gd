class_name Lootable
extends Interactable

@onready var inventory_component: InventoryComponent = $Components/InventoryComponent

## if [code]true[/code] Sorting tabs will be shown on the loot menu
@export var is_sortable: bool

func _ready() -> void:
	interactable_type = Globals.Interactable_Type.LOOTABLE
