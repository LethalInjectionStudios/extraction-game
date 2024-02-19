class_name POI
extends Node2D

@onready var area:Area2D = $Area2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_area_2d_body_entered(body):
	if body is Scenery:
		body.queue_free()