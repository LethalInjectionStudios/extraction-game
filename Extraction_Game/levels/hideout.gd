class_name Hideout
extends Level

var selected_raid : String = "res://levels/forest.tscn"

func _ready():
	super._ready()
	audio_listener.make_current()


func _process(delta):
	pass

func _load_scene() -> void:
	get_tree().change_scene_to_packed(load(selected_raid))

func _on_area_2d_body_entered(body):
	call_deferred("_load_scene")
