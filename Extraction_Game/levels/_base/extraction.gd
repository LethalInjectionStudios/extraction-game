class_name Extraction
extends Area2D

@export var extraction_timer: Timer
@export var extraction_timer_label: Label

var selected_raid: PackedScene = preload("res://levels/hideout/hideout.tscn")
var _player: Player

func _ready() -> void:
	z_index = global_position.y as int

func _process(_delta: float) -> void:
	if !extraction_timer.is_stopped():
		extraction_timer_label.text = str(extraction_timer.time_left)
	else:
		extraction_timer_label.text = ""

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_player = body as Player
		extraction_timer.start()



func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		extraction_timer.stop()


func _on_timer_timeout() -> void:	
	_player._save()
	call_deferred("_load_scene")


func _load_scene() -> void:
	get_tree().change_scene_to_packed(selected_raid)
