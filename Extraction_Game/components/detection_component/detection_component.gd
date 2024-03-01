class_name DetectionComponent
extends Area2D

signal actor_entered(actor: Node2D)
signal actor_left(actor: Node2D)

@export var parent: Character

func _on_body_entered(body: Node2D) -> void:
	if body != parent:
		actor_entered.emit(body)


func _on_body_exited(body: Node2D) -> void:
	if body != parent:
		actor_left.emit(body)
