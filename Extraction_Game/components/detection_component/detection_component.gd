class_name DetectionComponent
extends Area2D

var entered_body

func _on_body_entered(body):
	if body != get_parent():
		entered_body = body


func _on_body_exited(body):
	entered_body = null
