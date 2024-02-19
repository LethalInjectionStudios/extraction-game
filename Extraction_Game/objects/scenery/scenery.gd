class_name Scenery
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	calculate_z_index(global_position.y)


func calculate_z_index(y_position: float):
	sprite.z_index = y_position as int