class_name ItemDescription
extends Control
## Description Box when [InventoryItem] is hovered will display information about that item

# Base Values
@onready var _name: Label = $Container/Name
@onready var _type: Label = $Container/Type
@onready var _description: Label = $Container/Description

# Ammunition
@onready var _ammunition: VBoxContainer = $Container/Ammunition
@onready var _armor_penetration: ProgressBar = $Container/Ammunition/AP_Container/ArmorPenetration

# Weapon
@onready var _weapon_container: VBoxContainer = $Container/Weapon
@onready var _loaded_ammo: Label = $Container/Weapon/Loaded_Ammo
@onready var _weapon_durability: ProgressBar = $Container/Weapon/DurabilityContainer/WeaponDurability

# Armor
@onready var _armor_container: VBoxContainer = $Container/Armor
@onready var _ac_value: Label = $Container/Armor/AC_Container/AC_Value
@onready var _armor_durability: ProgressBar = $Container/Armor/DurabilityContainer/ArmorDurability

# Consumable
@onready var _consumable_container: VBoxContainer = $Container/Consumable
@onready var _health_container : HBoxContainer = $Container/Consumable/Health
@onready var _health_amount: Label = $Container/Consumable/Health/HealthAmount
@onready var _hunger_container: HBoxContainer = $Container/Consumable/Hunger
@onready var _hunger_amount: Label = $Container/Consumable/Hunger/HungerAmount
@onready var _thirst_container: HBoxContainer = $Container/Consumable/Thirst
@onready var _thirst_amount: Label = $Container/Consumable/Thirst/ThirstAmount


func _ready() -> void:
	clear()
	
func _process(_delta: float) -> void:
	if visible:
		global_position = get_global_mouse_position() + Vector2(15, 15)


func Show(item: InventoryItem) -> void:
	var _data: 	Item = load(item.item_path) as Item					
	
	_name.text = _data.name
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
			_weapon_durability.value = item.durability
			_weapon_container.visible = true
		Globals.Item_Type.ARMOR:
			var _armor: Armor = _data as Armor
			_ac_value.text = str(_armor.armor_class)
			_armor_durability.value = item.durability
			_armor_container.visible = true
		Globals.Item_Type.CONSUMABLE:
			var _consumable: Consumable = _data as Consumable
	
			if _consumable.health_restoration_amount != 0:
				_health_amount.text = str(_consumable.health_restoration_amount)
				if _consumable.health_restoration_amount > 0:
					_health_amount.modulate = Color(0,1,0,1)
				else:
					_health_amount.modulate = Color(1,0,0,1)
				_health_container.visible = true
				
			if _consumable.hunger_restoration_amount != 0:
				_hunger_amount.text = str(_consumable.hunger_restoration_amount)
				if _consumable.hunger_restoration_amount > 0:
					_hunger_amount.modulate = Color(0,1,0,1)
				else:
					_hunger_amount.modulate = Color(1,0,0,1)
				_hunger_container.visible = true
				
			if _consumable.thirst_restoration_amount != 0:
				_thirst_amount.text = str(_consumable.thirst_restoration_amount)
				if _consumable.thirst_restoration_amount > 0:
					_thirst_amount.modulate = Color(0,1,0,1)
				else:
					_thirst_amount.modulate = Color(1,0,0,1)
				_thirst_container.visible = true
				
			_consumable_container.visible = true
						
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
	_weapon_container.visible = false
	
	# Armor
	_armor_container.visible = false
	
	# Consumable
	_consumable_container.visible = false
	_health_container.visible = false
	_hunger_container.visible = false
	_thirst_container.visible = false
	
	
	





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
