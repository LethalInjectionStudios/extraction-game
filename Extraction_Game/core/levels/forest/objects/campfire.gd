class_name Campfire
extends StaticBody2D

@export var _particle_fire: CPUParticles2D


func _ready() -> void:
	_particle_fire.z_index = global_position.y as int
	z_index = position.y as int
	print("Fire Z index: ", _particle_fire.z_index)
