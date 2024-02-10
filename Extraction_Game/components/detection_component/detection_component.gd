class_name DetectionComponent
extends Area2D

signal actor_entered(actor)
signal actor_left(actor)

func _ready():
	printerr("NPC Detection Component will not work until refactored")


func _on_body_entered(body):
	actor_entered.emit(body)


func _on_body_exited(body):
	actor_left.emit(body)
