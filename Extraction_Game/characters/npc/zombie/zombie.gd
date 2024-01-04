class_name Zombie
extends CharacterBody2D

@export var move_speed: float = 100.0

const faction: Globals.Factions = Globals.Factions.ZOMBIE

var entered_body
var noise_heard: bool = false

func _ready():
	for actor in get_tree().get_nodes_in_group("Weapon"):
		actor.connect("noise_emitted", _on_weapon_fired)

	
func _process(delta):
	pass

	
func _physics_process(delta):
	move_and_slide()
		
		
func _on_weapon_fired(location):
	pass
	#if not entered_body:
		#direction = (location - position).normalized()
