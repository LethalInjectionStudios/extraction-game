class_name Scenery
extends StaticBody2D

@export var sprite: Sprite2D

func _ready() -> void:
	calculate_z_index(global_position.y)


func calculate_z_index(y_position: float) -> void:
	sprite.z_index = y_position as int
