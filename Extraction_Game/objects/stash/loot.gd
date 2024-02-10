class_name Loot
extends Interactable

@onready var inventory_component: InventoryComponent = $Components/InventoryComponent

func _ready():
    interactable_type = Globals.Interactable_Type.Lootable


func interact():
    print("This is the stash")
