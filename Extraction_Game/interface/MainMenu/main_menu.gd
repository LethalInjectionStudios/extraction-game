class_name MainMenu
extends Control

@export var play_button: Button
@export var scene: PackedScene

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(scene)
