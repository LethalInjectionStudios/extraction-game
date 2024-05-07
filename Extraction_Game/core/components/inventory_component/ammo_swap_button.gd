class_name AmmoSwapButton
extends Button

signal item_selected(item: InventoryItem)
signal item_hovered(item: InventoryItem)
signal item_hover_ended()

@export var audio_player: AudioStreamPlayer2D

var item: InventoryItem

func _ready() -> void:
	connect("pressed", _on_button_pressed)
	connect("mouse_entered", _on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_button_pressed() -> void:
	item_selected.emit(item)

func _on_mouse_entered() -> void:
	item_hovered.emit(item)
	audio_player.play()
	
func _on_mouse_exited() -> void:
	item_hover_ended.emit()
