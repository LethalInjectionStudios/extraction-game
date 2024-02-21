class_name Lootable
extends Interactable

@onready var inventory_component: InventoryComponent = $Components/InventoryComponent

func _ready():
    interactable_type = Globals.Interactable_Type.Lootable
