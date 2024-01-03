class_name Zombie
extends CharacterBody2D

var entered_body
var noise_heard: bool = false
var direction: Vector2
var speed: int = 25

@onready var detection_component: DetectionComponent = $DetectionComponent

func _ready():
	for actor in get_tree().get_nodes_in_group("Weapon"):
		actor.connect("noise_emitted", _on_weapon_fired)

	
func _process(delta):
	if not entered_body and not noise_heard:
		direction = Vector2.ZERO
		
	if detection_component.entered_body:
		direction = (detection_component.entered_body.global_position - position).normalized()
		
	velocity = direction * speed
	move_and_slide()
		
		
func _on_weapon_fired(location):
	if not entered_body:
		direction = (location - position).normalized()
