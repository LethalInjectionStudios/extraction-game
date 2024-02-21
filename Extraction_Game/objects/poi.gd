class_name POI
extends Node2D

@onready var area:Area2D = $Area2D

var sprites: Array[Sprite2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	_find_sprites(self)
	_set_sprite_z_level()


func _on_area_2d_body_entered(body):
	if body is Scenery:
		body.queue_free()


func _find_sprites(node: Node) -> void:
	if node is Sprite2D:
		sprites.append(node as Sprite2D)

	for child: Node in node.get_children():
		_find_sprites(child)


func _set_sprite_z_level() -> void:
	for child: Sprite2D in sprites:
		child.z_index = global_position.y as int