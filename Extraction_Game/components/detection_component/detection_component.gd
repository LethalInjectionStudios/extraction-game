class_name DetectionComponent
extends Area2D

signal actor_entered(actor)
signal actor_left(actor)

@export var parent: Character


func _on_body_entered(body):
	if body != parent:
		if body is Character:
			if body._faction != parent._faction:
				actor_entered.emit(body)


func _on_body_exited(body):
	actor_left.emit(body)
