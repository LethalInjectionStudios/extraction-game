extends Node

signal log_updated(log_data: String)

var _logger: Array[String]
	
func log(value: String, args: Array[Variant] = []) -> void:
	var new_string: String = ""
	var split: PackedStringArray = value.split(" ")
	for val: String in split:
		if val[0] == "{":
			if val[1].to_int() >= args.size():
				push_error("Missing or Not Enough Arguments")
				return
			else:
				new_string += str(args[int(val[1])]) + " "
		else:
			new_string += val + " "
	
	print(new_string)
	_logger.append(new_string)
	log_updated.emit(new_string)
