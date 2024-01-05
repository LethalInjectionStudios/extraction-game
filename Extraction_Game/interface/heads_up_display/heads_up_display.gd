class_name HeadsUpDisplay
extends Control

@onready var parent: Player = get_parent()
@onready var ammo_text: Label = $CanvasLayer/AmmoText
@onready var health_text: Label = $CanvasLayer/VBoxContainer/HealthText
@onready var hunger_text: Label = $CanvasLayer/VBoxContainer/HungerText
@onready var thirst_text: Label = $CanvasLayer/VBoxContainer/ThristText
@onready var fps_text: Label = $CanvasLayer/VBoxContainer2/FPSText
@onready var player_position_text: Label = $CanvasLayer/VBoxContainer2/PlayerPosText

func _process(_delta):
	fps_text.text = "FPS: " + str(Engine.get_frames_per_second())
	player_position_text.text = "Player Position: " + str(parent.global_position)
	
		
func update_display()-> void:
	ammo_text.text = str(parent.weapon_component.magazine_count) + "/" + str(parent.weapon_component.magazine_capacity)
	health_text.text = "Health: " + str(parent.health_component._health)
	hunger_text.text = "Hunger: " + str(parent._hunger)
	thirst_text.text = "Thirst: " + str(parent._thirst)


func _on_player_ui_changed():
	update_display()
