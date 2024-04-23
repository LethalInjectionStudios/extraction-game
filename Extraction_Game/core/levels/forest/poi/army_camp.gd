class_name ArmyCamp
extends POI

@export var spawn_points: Node2D
@export var characters: Node2D

const SOLDIER: PackedScene = preload("res://core/characters/npc/military/military_grunt.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

	for point: Node2D in spawn_points.get_children():
		var spawn_chance: float = randf()

		if spawn_chance > 0.5:
			var soldier_instance: EnemyBase = SOLDIER.instantiate()
			soldier_instance.position = point.position
			characters.add_child(soldier_instance)
