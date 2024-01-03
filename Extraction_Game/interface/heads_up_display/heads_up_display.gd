class_name HeadsUpDisplay
extends Control

@onready var owning_actor: Player = get_parent()
@onready var ammo_text: Label = $CanvasLayer/AmmoText
@onready var health_text: Label = $CanvasLayer/VBoxContainer/HealthText
@onready var hunger_text: Label = $CanvasLayer/VBoxContainer/HungerText
@onready var thirst_text: Label = $CanvasLayer/VBoxContainer/ThristText
	
	
func update_display()-> void:
	ammo_text.text = str(owning_actor.weapon_component.magazine_count) + "/" + str(owning_actor.weapon_component.magazine_capacity)
	health_text.text = "Health: " + str(owning_actor._health)
	hunger_text.text = "Hunger: " + str(owning_actor._hunger)
	thirst_text.text = "Thirst: " + str(owning_actor._thirst)


func _on_player_ui_changed():
	update_display()
