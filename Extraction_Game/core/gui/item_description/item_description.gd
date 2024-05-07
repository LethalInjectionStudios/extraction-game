class_name ItemDescription
extends VBoxContainer
## Description Box when [InventoryItem] is hovered will display information about that item

#Base Values
@onready var _name: Label = $Name
@onready var _type: Label = $Type
@onready var _description: Label = $Description

#Ammunition
@onready var _ammunition: VBoxContainer = $Ammunition
@onready var _armor_penetration: ProgressBar = $Ammunition/AP_Container/ArmorPenetration

#Weapon
@onready var _loaded_ammo: Label = $Weapon/Loaded_Ammo


func _ready() -> void:
	clear()


func Show(item: InventoryItem) -> void:
	var _data: Item = load(item.item_path) as Item	
	
	_name.text = item.item_name
	_name.visible = true
		
	_type.text = Globals.get_item_type_as_string(item.item_type)
	_type.visible = false
	
	_description.text = _data.description
	_description.visible = true
		
	match item.item_type:
		Globals.Item_Type.AMMO:
			var _ammo: Ammunition = _data as Ammunition
			_description.visible = false
			_armor_penetration.value = _ammo.penetration
			_ammunition.visible = true
		Globals.Item_Type.WEAPON:
			var _weapon: Weapon = _data as Weapon
			var _ammo: Ammunition = load(item.ammo_type)
			_name.text += " (" + _ammo.name + ")"
			
				
	#position = get_global_mouse_position()
	visible = true
	
func Hide() -> void:
	clear()
	visible = false

func clear() -> void:
	# Base Values
	_name.visible = false	
	_type.visible = false	
	_description.visible = false

	# Ammunition
	_ammunition.visible = false
	
	# Weapon
	_loaded_ammo.visible = false
	
	
	





	#item_description.append_text("Type: ")
	#match item.item_type:
		#Globals.Item_Type.JUNK:
			#item_description.append_text("Junk")
		#Globals.Item_Type.WEAPON:
			#item_description.append_text("Weapon")
		#Globals.Item_Type.AMMO:
			#var ammo: Ammunition = load(item.item_path) as Ammunition
			#item_description.append_text("Ammo")
			#item_description.newline()
			#item_description.append_text(Globals.get_caliber_as_string(ammo.caliber))
		#Globals.Item_Type.MEDICATION:
			#item_description.append_text("Health")
		#Globals.Item_Type.CRAFTING_MATERIAL:
			#item_description.append_text("Materials")
		#Globals.Item_Type.ARMOR:
			#var armor: Armor = load(item.item_path) as Armor
			#item_description.append_text("Armor")
			#item_description.newline()
			#item_description.append_text("Armor Class: " + str(armor.armor_class))
			#item_description.newline()
			#item_description.append_text("Durability: " + str(item.durability) + " (" + Globals.get_armor_status_as_string(item.status) + ")")
	#item_description.newline()
