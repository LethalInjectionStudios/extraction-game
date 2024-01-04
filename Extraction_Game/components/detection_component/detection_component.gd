class_name DetectionComponent
extends Area2D

signal actor_entered(actor)
signal actor_left(actor)

var entered_body

func _on_body_entered(body):
	if body != get_parent():
		entered_body = body
		actor_entered.emit(body)


func _on_body_exited(body):
	actor_left.emit(body)
	entered_body = null
