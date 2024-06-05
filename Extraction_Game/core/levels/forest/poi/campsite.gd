class_name Campsite
extends POI

@export var lootables: Array[Lootable]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	_setup()
	
func _setup() -> void:
	for lootable: Lootable in lootables:
		var rand: int = randi_range(0, 2)
		
		if rand != 2:
			lootable.queue_free()
