class_name Logger
extends Control

@onready var log_container: VBoxContainer = $CanvasLayer/ScrollContainer/VBoxContainer
@onready var canvas_layer: CanvasLayer = $CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	System.log_updated.connect(_on_log_updated)

		
func toggle_log() -> void:
	canvas_layer.visible = !canvas_layer.visible

		
func _on_log_updated(log_data: String) -> void:
	var data: Label = Label.new()
	data.text = log_data
	log_container.add_child(data)
