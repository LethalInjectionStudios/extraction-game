class_name DetectionComponent
extends Area2D

signal actor_entered(actor: Node2D)
signal actor_left(actor: Node2D)

func _ready() -> void:
	printerr("NPC Detection Component will not work until refactored")


func _on_body_entered(body: Node2D) -> void:
	print(body)
	actor_entered.emit(body)


func _on_body_exited(body: Node2D) -> void:
	actor_left.emit(body)
