class_name Campfire
extends StaticBody2D

@export var _particle_fire: CPUParticles2D


func _ready() -> void:
	_particle_fire.z_index = _particle_fire.global_position.y as int
