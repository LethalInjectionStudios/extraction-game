class_name Extraction
extends Area2D

var selected_raid : String = "res://levels/hideout.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if body is Player:
		call_deferred("_load_scene")
		
	
func _load_scene() -> void:
	get_tree().change_scene_to_packed(load(selected_raid))
