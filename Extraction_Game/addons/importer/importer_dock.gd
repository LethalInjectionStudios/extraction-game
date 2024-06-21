@tool
extends Control

# Do NOT change the order of the columns in the csv file or this will break

@onready var file_path: TextEdit = $"VBoxContainer/File Path"
@onready var import_type: OptionButton = $"VBoxContainer/Import Type"

func _on_import_button_down() -> void:
	if !file_path.text.contains(".csv"):
		push_warning("Please provide a valid File Path")
		return
	
	match import_type.selected:
		-1:
			push_warning("Please select an Import Type")
			return
		0:
			_import_weapons()
		1:
			_import_ammo()
			
	import_type.selected = -1
	file_path.text = ""
		
func _import_weapons() -> void:
	var file: FileAccess = FileAccess.open(file_path.text, FileAccess.READ)
	if file:
		var column_names: PackedStringArray
		var counter: int = 0
		while file.get_position() < file.get_length():
			var content: String = file.get_line()
			var item: PackedStringArray = content.split(",")
			if counter == 0:
				column_names = content.split(",")
				
			if counter != 0:
				var integrity_check = 0
				for column in item:
					if column == "":
						push_error("Row ", counter + 1, " ", column_names[integrity_check], " missing data")
					integrity_check += 1
				
				if item[3] != "":					
					var weapon: Weapon = load(item[3]) as Weapon
										
					weapon.name = item[0]
					weapon.type = Globals.Item_Type.WEAPON
					
					weapon.damage = item[4] as int
					weapon.accuracy = item[5] as int
					weapon.recoil = item[6] as int
					weapon.ergonomics = item[7] as int
					weapon.sound = item[8] as int
					weapon.rate_of_fire = item[9] as float
					weapon.caliber = _get_caliber_from_string(item[10])
					if weapon.caliber == Globals.Caliber.MISSING:
						push_error("Row ", counter + 1, " Missing Caliber, _get_caliber_from_string() likely out of sync")
					weapon.weight = item[11] as float
					weapon.stock_swappable = _parse_bool(item[13])
					weapon.stock_required = _parse_bool(item[14])
					weapon.handguard_swappable = _parse_bool(item[15])
					weapon.handguard_required = _parse_bool(item[16])
					weapon.grip_swappable = _parse_bool(item[17])
					weapon.grip_required = _parse_bool(item[18])
					weapon.barrel_swappable = _parse_bool(item[19])
					weapon.barrel_required = _parse_bool(item[20])
					weapon.magazine_swappable = _parse_bool(item[21])
					weapon.magazine_required = _parse_bool(item[22])
					weapon.muzzle_required = _parse_bool(item[23])
					weapon.muzzle_required = _parse_bool(item[24])
					weapon.scope_swappable = _parse_bool(item[25])
					weapon.scope_required = _parse_bool(item[26])
					ResourceSaver.save(weapon)
					print(weapon.name, " has been successfully updated")
				else:
					push_error("Row ", counter + 1, " missing file path")				
			counter += 1


func _import_ammo() -> void:
	var file: FileAccess = FileAccess.open(file_path.text, FileAccess.READ)
	if file:
		var column_names: PackedStringArray
		var counter: int = 0
		while file.get_position() < file.get_length():
			var content: String = file.get_line()
			var item: PackedStringArray = content.split(",")
			if counter == 0:
				column_names = content.split(",")
				
			if counter != 0:
				var integrity_check = 0
				for column in item:
					if column == "":
						push_error("Row ", counter + 1, " ", column_names[integrity_check], " missing data")
					integrity_check += 1
				
				if item[1] != "":
					var ammo: Ammunition = load(item[1]) as Ammunition
					print(item[0])
					
					ammo.name = item[0]
					ammo.type = Globals.Item_Type.AMMO
					ammo.caliber = _get_caliber_from_string(item[2])
					ammo.weight = item[3] as float
					ammo.armor_penetration = item[4] as int
					ammo.damage_modifier = item[5] as int
					ammo.accuracy_modifier = item[6] as int
					ammo.recoil_modifier = item[7] as int
					ammo.durability_burn = item[8] as float
					ammo.sound_modifier = item[9] as int
					ResourceSaver.save(ammo)
			counter += 1

					
func _get_caliber_from_string(caliber: String) -> Globals.Caliber:
	match caliber:
		"7.62 x 39":
			return Globals.Caliber._762x39
		"9 x 18":
			return Globals.Caliber._9x18
		"9 x 19":
			return Globals.Caliber._9x19
		"5.7 x 28":
			return Globals.Caliber._57x28
		"5.45 x 39":
			return Globals.Caliber._545x39
		"5.56 x 45":
			return Globals.Caliber._556x45
		"7.62 x 25":
			return Globals.Caliber._762x39
		"12 Gauge":
			return Globals.Caliber._12GAUGE
		_:
			return Globals.Caliber.MISSING
	

func _parse_bool(bool_string: String) -> bool:
	var result: bool
	
	match bool_string:
		"TRUE":
			result = true
		"FALSE":
			result = false
			
	return result
