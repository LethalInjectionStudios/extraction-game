@tool
extends Control

# Do NOT change the order of the columns in the csv file or this will break

@onready var file_path: TextEdit = $"VBoxContainer/File Path"

func _on_import_button_down() -> void:
	var file: FileAccess = FileAccess.open(file_path.text, FileAccess.READ)
	if file:
		var counter: int = 0
		while file.get_position() < file.get_length():
			var content: String = file.get_line()
			var item: PackedStringArray = content.split(",")
			if counter == 1:
				var res: Weapon = load(item[3]) as Weapon
				res.name = item[0]
				print(res.name)
				ResourceSaver.save(res)
			counter += 1
